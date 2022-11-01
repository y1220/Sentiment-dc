#!/bin/bash

usage() { echo "Usage: $0 [-s <web|db|pgadmin4>] [-f]" 1>&2; exit 1; }

while getopts ":s:f" o; do
    case "${o}" in
        s)
            SERVICE=${OPTARG}
            ((SERVICE == "web" || SERVICE == "db" || SERVICE == "pgadmin4")) || usage
            ;;
        f)
            FOLLOW=true
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${SERVICE}" ]; then
    SERVICE="web"
fi

echo "Starting services..."
docker-compose up -d

echo "Detatched from stack!"

if [ -n "${FOLLOW}" ]; then
    echo "Following ${SERVICE} service logs.."
    echo "Press [CTRL+C] to exit ${SERVICE} service logs!"
    docker-compose logs "${SERVICE}" -f
else
    echo "If you want to follow the logs run this script with -f and -s to specify the service."
    usage
fi