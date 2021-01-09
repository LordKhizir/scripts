#!/bin/bash
set -e

errorheader="\033[1;31mERROR\033[0m"

# check if there are rar files left behind
rarpresence=`find . -name '*.rar'`

if test ! -z "${rarpresence}"
then
    echo -e "$errorheader: Rar file found"
    echo "$rarpresence"
fi


# check if there are zip files left behind
zippresence=`find . -name '*.zip'`

if test ! -z "${zippresence}"
then
    echo -e "$errorheader: Zip file found"
    echo "$zippresence"
fi

# check if there are stl files uncompressed
stlpresence=`find . -name '*.stl'`

if test ! -z "${stlpresence}"
then
    echo -e "$errorheader: Stl file found"
    echo "$stlpresence"
fi

# check if there are 7z files
IFS=$'\n' compressed7zpresence=`find . -name '*.7z'`

if [[ ! `echo "$compressed7zpresence"|wc -l|awk {'print $1'}` -gt 0 ]]
then
    echo -e "$errorheader: no 7z files found"
fi

# gets the compression ratio and recommends better compression for the files with less than 24
re='^[0-9]+$'
for file in $compressed7zpresence; do
    compression_ratio=`7z l "$file" |grep "Method"|cut -d":" -f2|awk {'print $1'}`
    if [[ "$compression_ratio" =~ $re ]] && [[ "$compression_ratio"  -lt 24 ]]; then
        echo -e "compression ratio \033[1;33m${compression_ratio}\033[0m can be improved on \033[1;37m${file}\033[0m"
    fi
done
