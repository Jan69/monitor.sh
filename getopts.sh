#!/bin/sh
#getopts is in bash and apparently even old bourne shell
exec_getopts(){
while getopts "c:f:" arg; do
  case "${arg}" in
    c) command="${OPTARG}" ;;
    f) file="${OPTARG}";"$command" "$file";;
    ?) echo "Invalid option: -${OPTARG}." ;;
  esac
done
}
