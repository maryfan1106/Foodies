# Foodies

## Prerequisites

Download the [DOHMH New York City Restaurant Inspection Results][1] as a "TSV
for Excel" and name it "inspections.tsv".

[1]: https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j

## Database

Initialize the database:

```sh
sqlite3 foodies.sqlite3 < database/initialize.sql
```

Gather data from the various sources:

```sh
julia --project=database -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'
JULIA_NUM_THREADS=4 julia --project=database database/get_data.jl
```

Ideally, the database should be stored in memory as gathering data produces many write operations.
