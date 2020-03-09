# Foodies

Initialize the database:

```sh
$ sqlite3 foodies.sqlite3 < database/initialize.sql
$ JULIA_NUM_THREADS=4 database/get_data.jl
```

Ideally, the database should be stored in memory as gathering data produces many
write operations.
