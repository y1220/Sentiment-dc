#!/bin/bash

usage() { echo "Usage: $0 [-s <web|db|pgadmin4>] [-m <bash|sh>]" 1>&2; exit 1; }

while getopts ":s:m:" o; do
    case "${o}" in
        s)
            SERVICE=${OPTARG}
            ((SERVICE == "web" || SERVICE == "db" || SERVICE == "pgadmin4")) || usage
            ;;
        m)
            MODE=${OPTARG}
            ((MODE == "bash" || MODE == "sh")) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Not needed (lenient in development mode)
# if [ -z "${SERVICE}" ] || [ -z "${MODE}" ]; then
#     usage
# fi

if [ -z "${SERVICE}" ]; then
    SERVICE="web"
fi

if [ -z "${MODE}" ]; then
    MODE="bash"
fi

if [ "${SERVICE}" = "pgadmin4" ] && [ "${MODE}" = "bash" ]; then
    echo "${MODE} mode not supported for ${SERVICE} service. Using sh!"
    MODE="sh"
fi

echo "Exec into ${SERVICE} in ${MODE} mode.."
docker-compose exec "${SERVICE}" "${MODE}"