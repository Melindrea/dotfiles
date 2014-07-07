#!/bin/bash
# ~/bin/dpkg
COUNT=0
for i in $@; do
        echo $i | grep http 2>&1 > /dev/null
        if [ $? == 0 ]; then
                URL="$URL $i"
                continue
        fi
        PASSTODPKG="$PASSTODPKG $i"
done

#Remove beginning and trailing space
URL=$(echo $URL | sed -e 's/^ //g' -e 's/ $//g')

if [ ! -z $URL ]; then
        mkdir /tmp/debs
        cd /tmp/debs
        for i in $URL; do
                wget "$i"
        done
        dpkg $PASSTODPKG /tmp/debs/*.deb
else
        dpkg $PASSTODPKG
fi
