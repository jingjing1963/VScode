#!/bin/bash
folder=bash_homework/
cd $folder
CUR_DIR=`ls`
for val in $CUR_DIR
do
if [ -f $val ];then
echo $val >> ../filenames.txt
elif [ -d $val ];then
echo $val >> ../dirname.txt
fi
done

exit 0