#!/bin/bash

# Removes duplicate files based on MD5 Sum

list="./listOfFiles"        # Assign filename to list
folder="./duplicateFiles"    # Assign foldername to dup location

if [ ! -f $list ]            # Check if list file exist
then
    me=`basename $0`        # Get name of script to remove from directory listing
    ls > ./listOne            # Create list of files in directory
    grep -v listOne ./listOne | grep -v $me > listOfFiles    # Remove list name and script name
    rm ./listOne            # Clean up
fi

if [ ! -d $folder ]            # If duplicateFiles folder doesn't exist, create it
then
    mkdir -p $folder
fi

while read files             # Read listOfFiles line by line assinging files var
do
    if [ -a $files ]
    then
        firstSum=$(md5 $files | cut -d " " -f 4)        # Create MD5 SUM and assign to firstSum var
        while read files2        # Read listOfFiles line by line assigning files2 var
        do
            if [ -a $files2 ]        # If file exists in dir, hasn't been moved yet, continue
            then
                secondSum=$(md5 $files2 | cut -d " " -f 4)
                if [ "$files" == "$files2" ]        # If comparing the same file, pass
                then
                    :
                else
                    if [ "$firstSum" == "$secondSum" ]        # If sums are the same, move to duplicateFiles dir
                    then
                        echo 'MOVING:' $files2        # Tell user what's happening
                        mv $files2 $folder
                    fi
                fi
            fi
        done < $list
    fi
done < $list
