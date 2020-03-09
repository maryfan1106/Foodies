# Foodies

Initialize the database:

```sh
$ sqlite3 foodies.sqlite3 < database/initialize.sql
$ JULIA_NUM_THREADS=4 database/get_data.jl
```
