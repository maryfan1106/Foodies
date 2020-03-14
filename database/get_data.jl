#!/usr/bin/env julia

# required environement variables: YELP_TOKEN, GPLACES_TOKEN

module GetData

using Base.Iterators: partition
using JSON3
using HTTP: post
using SQLite: DB, Stmt
using DBInterface: execute
using Tables: rowtable

const SQL_PRICE = "INSERT INTO prices (camis, source, price)
                   VALUES (:camis, :source, :price)"

const SQL_HOURS = "INSERT INTO openhours (camis, source, dayofweek, open, close)
                   VALUES (:camis, :source, :dayofweek, :open, :close)"

struct Exec
    stmt::Stmt
    args::NamedTuple
end

function db_write(ch)
    while isopen(ch)
        exe = take!(ch)
        execute(exe.stmt, exe.args)
    end
end

struct DBConnection
    db::DB
    price_stmt::Stmt
    hours_stmt::Stmt
    ch::Channel
end

function DBConnection(dbfile)
    db = DB(dbfile)
    DBConnection(db, Stmt(db, SQL_PRICE), Stmt(db, SQL_HOURS), Channel(db_write))
end

function get_missing_rows(dbc, source)
    sql = Stmt(dbc.db,
               "SELECT DISTINCT  r.camis, r.name, r.address, r.phone, r.lat, r.long
                FROM             restaurants AS r
                CROSS JOIN       sources     AS s
                WHERE NOT EXISTS (SELECT 1 FROM prices    AS p
                                  WHERE r.camis = p.camis AND p.source = :source)
                  AND NOT EXISTS (SELECT 1 FROM openhours AS o
                                  WHERE r.camis = o.camis AND o.source = :source)")

    execute(sql, (source = source,))
end

insert_price(dbc, camis, price, source) =
    put!(dbc.ch, Exec(dbc.price_stmt, (camis = camis, price = price, source = source)))

function process_yelp_single(dbc, headers, row)
    (camis, name, address, phone, lat, long) = row
    addr, zipcode = rsplit(address; limit = 2)

    res = post("https://api.yelp.com/v3/graphql", headers, """
                {
                    business_match(
                        name: "$(escape_string(name))",
                        address1: "$(escape_string(addr))",
                        city: "New York",
                        state: "NY",
                        country: "US",
                        $(lat isa Number ? "latitude: $lat," : "")
                        $(long isa Number ? "longitude: $long," : "")
                        phone: "$phone",
                        postal_code: "$zipcode",
                        limit: 1
                    ) {
                        total
                        business {
                            price
                            hours {
                                open {
                                    day
                                    start
                                    end
                                }
                            }
                        }
                    }
                }""")

    data = JSON3.read(res.body).data.business_match
    @info "YELP" name

    if data.total == 1
        b = data.business[1]
        price = (b.price isa String ? length(b.price) : "NULL")
        insert_price(dbc, camis, price, 2)

        if length(b.hours) > 0
            for (day, from, to) in b.hours[1].open
                put!(dbc.ch, Exec(dbc.hours_stmt, (camis = camis, source = 2, dayofweek =
                                                   day[2], open = from[2], close = to[2])))
            end
        end
    end
end

function process_yelp(dbc)
    missing_rows = get_missing_rows(dbc, 2) |> rowtable

    headers = Dict("Authorization" => "Bearer $(ENV["YELP_TOKEN"])",
                   "Content-Type" => "application/graphql")

    for rows in partition(missing_rows, 4)
        wait.(Threads.@spawn process_yelp_single(dbc, headers, row) for row in rows)
        sleep(0.2) # avoid too many calls per second
    end
end

function process_gplaces_single(dbc, query, row)
    (camis, name, address, phone, lat, long) = row

    res = post("https://maps.googleapis.com/maps/api/place/findplacefromtext/json";
               query = merge(query, Dict(:input => name,
                                         :inputtype => "textquery",
                                         :locationbias => "point:$lat,$long",
                                         :fields => "place_id")))

    candidates = JSON3.read(res.body).candidates
    length(candidates) < 1 && return
    place_id = candidates[1].place_id

    res = post("https://maps.googleapis.com/maps/api/place/details/json";
               query = merge(query, Dict(:place_id => place_id,
                                         :fields => "opening_hours/periods,price_level")))

    data = JSON3.read(res.body).result
    @info "GPLACES" name

    try
        periods = data.opening_hours.periods
        for (close, open) in periods
            put!(dbc.ch, Exec(dbc.hours_stmt, (camis = camis, source = 1, dayofweek =
                                               open[2].day, open = open[2].time, close =
                                               close[2].time)))
        end
    catch BoundsError # no opening hours
    end

    price = get(data, "price_level", "NULL")
    insert_price(dbc, camis, price, 1)
end

function process_gplaces(dbc)
    missing_rows = get_missing_rows(dbc, 1) |> rowtable
    query = Dict(:key => ENV["GPLACES_TOKEN"])

    for rows in partition(missing_rows, 4)
        wait.(Threads.@spawn process_gplaces_single(dbc, query, row) for row in rows)
    end
end

end


function main()
    db = GetData.DBConnection("foodies.sqlite3")
    GetData.process_yelp(db)
    GetData.process_gplaces(db)
end

isinteractive() || main()
