#!/bin/bash
cd $1
fullVersion=$(cat $2)
echo "version before increment: ${fullVersion}"
patchedVersion="${fullVersion%.*}.$((${fullVersion##*.} + 1))"
echo "new Version is: $patchedVersion"
echo "Saving to File: $PWD/VERSION"
echo $patchedVersion > VERSION




# echo $fullVersion | (IFS=. read v1 v2 v3)
# echo "v: $v1 $v2 $v3"
# echo "### version before increment: " $fullVersion
# ((v3++))
# newVersion="${v1}.${v2}.${v3}"
# echo "### version after increment: " $newVersion
# echo $newVersion >>> VERSION
# echo 'file:  $(cat VERSION)'