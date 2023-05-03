#!/bin/bash
cd $1
fullVersion=$(cat $2)
echo "version before increment: ${fullVersion}"
patchedVersion="${fullVersion%.*}.$((${fullVersion##*.} + 1))"
echo "new Version is: $patchedVersion"
echo "Saving to File: $PWD/VERSION"
echo $patchedVersion > VERSION