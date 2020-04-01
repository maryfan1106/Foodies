#!/usr/bin/env sh
set -e

cd "$(dirname "$0")"

tmpdir=$(mktemp -d)

cleanup() {
    rm -rf "$tmpdir"
}
trap cleanup INT TERM

rsync -a --exclude node_modules server/ "$tmpdir/"
cp foodies.sqlite3 "$tmpdir/"
sed -i 's|../foodies.sqlite3|./foodies.sqlite3|' "$tmpdir/db.js"

cd "$tmpdir" || exit

git init
git add .
git commit -m 'initial commit'
git remote add heroku https://git.heroku.com/the-last-resort.git
git push --force heroku master
