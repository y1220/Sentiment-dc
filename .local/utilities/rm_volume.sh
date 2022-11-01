
#!/bin/bash

usage() { echo "Usage: $0 [-v <string>]  [-s <db-data>]" 1>&2; exit 1; }

while getopts ":v:s:" o; do
    case "${o}" in
        v)
            VOLUME=${OPTARG}
            ;;
        s)
            SUFFIX=${OPTARG}
            ((SUFFIX == "db-data")) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR=$( dirname "$( dirname "${SCRIPT_DIR}" )" )

PROJECT_NAME=$( echo "$( basename "${PROJECT_DIR}")" | tr '[:upper:]' '[:lower:]'"")

if [ -z "${SUFFIX}" ]; then
    SUFFIX="db-data"
fi

if [ -z "${VOLUME}" ]; then
    VOLUME_NAME="${PROJECT_NAME}_${SUFFIX}"
    echo "Since no -v option has been passed, I am trying to remove volume ${VOLUME_NAME}.."
else
    VOLUME_NAME="${VOLUME}"
fi

read -p "Are you sure you want to remove volume '${VOLUME_NAME}'? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

docker volume rm "${VOLUME_NAME}"