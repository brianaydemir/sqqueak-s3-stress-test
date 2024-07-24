#!/bin/bash
# Check if the correct number of positional arguments is provided
if [ $# -ne 3 ]; then
        echo "Usage: $0 [mc|pel] [get|put]"
        exit 1
fi

# Check if the first argument is "mc" or "pel"
if [ $1 = "mc" ]; then
        if [ $2 = "get" ]; then
                echo "[::: Getting files via mc from research-drive/jhiemstra/files :::]"
                mc cp -r research-drive/jhiemstra/files .
        elif [ $2 = "put" ]; then
                echo "[::: Sending files via mc to research-drive/jhiemstra/files :::]"
                mc cp -r files research-drive/jhiemstra
        else
                echo "Invalid second argument for 'mc'. Usage: $0 mc [get|put]"
                exit 1
        fi
elif [ $1 = "pel" ]; then

        if [ $2 = "get" ]; then
                echo "[::: Getting files via pelican from research-drive/jhiemstra/files :::]"
                pelican object get -r -f https://osg-htc.org -t $3 /test-rdrive-s3/jhiemstra/files .
        elif [ $2 = "put" ]; then
                echo "[::: Sending files via pelican to research-drive/jhiemstra/files :::]"
                pelican object put -r -f https://osg-htc.org -t $3 files /test-rdrive-s3/jhiemstra
        else
                echo "Invalid second argument for 'pel'. Usage: $0 pel [get|put]"
                exit 1
        fi
else
        echo "Invalid first argument. Usage: $0 [mc|pel] [get|put]"
        exit 1
fi

echo "[::: Complete :::]"
exit 0
