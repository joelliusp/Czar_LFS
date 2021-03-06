#!/bin/bash

echo "In Script Runner"
while [ "$#" -gt 0 ]; do
	case "$1" in
		--at_test=*)
			at_test="${1#*=}"
		;;
		--src_script=*)
			src_script="${1#*=}"
		;;
		--script_dir=*)
			script_dir="${1#*=}"
    ;;
		*) : ;;	
	esac
  shift
done
if [ -e "$scr_script" ]; then
	echo "source script not found" 
	exit 1
fi &&
. "$src_script" &&
cd "$script_dir" &&
for s in "${scripts[@]}"; do
	if [ -n "$at_test" ] && [ -z "$lastScript" ]; then
		[ "$at_test" != "$s" ] && continue
	fi	
	bash "$s" && lastScript="$s" ||
	{ echo "One of the blasted scripts failed"; exit 1; }
done && 
[ -n "$lastScript" ] &&
{ echo "All scripts succeeded!"; exit 0; } ||
{ echo "Something else went wrong"; exit 1; }
