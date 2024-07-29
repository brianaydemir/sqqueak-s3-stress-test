#!/bin/bash

set -eux


# Required to run `mc` from the current working directory.
export PATH=".:$PATH"


# Hard-code command-line flags and path prefixes
mc_cmd="./mc --config-dir .mc --debug"
mc_object_prefix="jhiemstra/jhiemstra/doit-s3-scaling-test/mc"
pelican_cmd="pelican -f https://osg-htc.org -t pelican-token.tok --debug"
pelican_object_prefix="/test-rdrive-s3/jhiemstra/doit-s3-scaling-test/pelican"


# Check if the correct number of positional arguments is provided
if [ $# -ne 3 ]; then
        echo "Usage: $0 [mc|pelican] [get|put] [file]"
        exit 1
fi


# Check if the first argument is "mc" or "pelican"
if [ "$1" = "mc" ]; then
        if [ "$2" = "get" ]; then
                echo "[::: Getting ${3} via mc from ${mc_object_prefix} :::]"
                ${mc_cmd} cp "${mc_object_prefix}/${3}" "${3}"
        elif [ "$2" = "put" ]; then
                echo "[::: Sending ${3} via mc to ${mc_object_prefix} :::]"
                ${mc_cmd} cp "${3}" "${mc_object_prefix}/${3}"
        else
                echo "Invalid second argument for 'mc'. Usage: $0 mc [get|put] [file]"
                exit 1
        fi
elif [ "$1" = "pelican" ]; then
        if [ "$2" = "get" ]; then
                echo "[::: Getting ${3} via pelican from ${pelican_object_prefix} :::]"
                ${pelican_cmd} object get "${pelican_object_prefix}/${3}" "${3}"
        elif [ "$2" = "put" ]; then
                echo "[::: Sending ${3} via pelican to ${pelican_object_prefix} :::]"
                ${pelican_cmd} object put "${3}" "${pelican_object_prefix}/${3}"
        else
                echo "Invalid second argument for 'pelican'. Usage: $0 pelican [get|put] [file]"
                exit 1
        fi
else
        echo "Invalid first argument. Usage: $0 [mc|pelican] [get|put] [file]"
        exit 1
fi

echo "[::: Complete :::]"
exit 0
