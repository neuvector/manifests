#!/bin/bash

target="$1"

case $target in
	fleet)
		./make_fleet.sh || { echo "Failed make_fleet.sh"; exit 1; }
		;;
	db)
		./make_db.sh || { echo "Failed make_db.sh"; exit 1; }
		;;
	dbgen)
		./make_db.sh || { echo "Failed make_db.sh"; exit 1; }
		;;
	manager)
		./make_jar.sh -d || { echo "Failed make_jar.sh"; exit 1; }
		;;
	*)
		echo $"Usage: $0 {fleet|manager|db}"
		exit 1
esac
