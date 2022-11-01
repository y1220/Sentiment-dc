#!/bin/bash

usage() { echo "Usage: $0 [-s <string>]" 1>&2; exit 1; }

while getopts ":s:" o; do
    case "${o}" in
        s)
            SEED=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "Creating DB.."
docker-compose exec web rails db:create

echo "Migrating DB.."
docker-compose exec web rails db:migrate

if [ -z "${SEED}" ]; then
    SEED="seed"
fi

read -p "Do you want to seed the db? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
docker-compose exec web rails "db:${SEED}"

