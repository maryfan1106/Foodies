#!/usr/bin/env julia

# required environement variables: YELP_TOKEN

module GetData

using JSON3
using HTTP: post
using SQLite: DB, Stmt
using DBInterface: execute
using Tables: rowtable

const SQL_PRICE = "INSERT INTO prices (camis, source, price)
                   VALUES (:camis, :source, :price)"

const SQL_HOURS = "INSERT INTO openhours (camis, source, dayofweek, open, close)
                   VALUES (:camis, :source, :dayofweek, :open, :close)"

struct DBConnection
    db::DB
    price_stmt::Stmt
    hours_stmt::Stmt
end

function DBConnection(dbfile)
    db = DB(dbfile)
    DBConnection(db, Stmt(db, SQL_PRICE), Stmt(db, SQL_HOURS))
end

function get_missing_rows(dbc, source)
    sql = Stmt(dbc.db,
               "SELECT    r.camis, r.name, r.address, r.phone, r.lat, r.long
                FROM      restaurants AS r
                LEFT JOIN prices      AS p ON r.camis = p.camis AND p.source = :source
                LEFT JOIN openhours   AS o ON r.camis = o.camis AND p.source = :source
                WHERE price IS NULL AND open IS NULL AND close IS NULL")

    execute(sql, (source = source,))
end

function insert_price(dbc, camis, price, source)
    execute(dbc.price_stmt, (camis = camis, price = price, source = source))
end

function insert_hours(dbc, camis, hours, source)
    for (day, from, to) in hours
        execute(dbc.hours_stmt, (camis = camis, source = source, dayofweek = day[2],
                                 open = from[2], close = to[2]))
    end
end

function process_gplaces(dbc)
    missing_rows = get_missing_rows(dbc, :gplaces) |> rowtable
end

function process_yelp(dbc)
    done = 0
    missing_rows = get_missing_rows(dbc, 2) |> rowtable

    headers = Dict("Authorization" => "Bearer $(ENV["YELP_TOKEN"])",
                   "Content-Type" => "application/graphql")

    for (camis, name, address, phone, lat, long) in missing_rows
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

        if res.status == 429
            @info "Yelp quota reached. Added data for $done/$(length(missing_rows)) rows."
            return
        else
            data = JSON3.read(res.body)["data"]["business_match"]
            @info name

            if data["total"] == 1
                b = data["business"][1]
                price = (b["price"] isa String ? length(b["price"]) : "NULL")
                Threads.@spawn insert_price(dbc, camis, price, 2)
                length(b["hours"]) > 0 &&
                    Threads.@spawn insert_hours(dbc, camis, b["hours"][1]["open"], 2)
                done += 1
            end

        end
    end
end

end


function main()
    db = GetData.DBConnection("foodies.sqlite3")
    GetData.process_yelp(db)
end

isinteractive() || main()
