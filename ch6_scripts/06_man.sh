#!/bin/bash

time {
app=man-pages-4.16
echo "Running $app"
cd /sources
rm -rf "$app"
tar -xf "$app".tar.xz
cd "$app" &&
make install &&
{ echo "Winner is $app"; status=0; } ||
{ echo "Loser is $app"; status=1; }
cd /sources &&
rm -rf "$app"
}

exit "$status"
