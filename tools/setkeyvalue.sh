#!/bin/bash
FILE=$1
KEY=$2
VALUE=$3
QUOTE=$4
if [[ -z "$QUOTE" ]] ; then
    QUOTE='"'	
fi
if ! grep -qs "^${KEY}=" "$FILE" ; then
    echo "$KEY=" >> "$FILE"
fi
sed -i -e "s#^${KEY}=.*#${KEY}=${QUOTE}${VALUE}${QUOTE}#" "${FILE}"
echo "${VALUE}"
