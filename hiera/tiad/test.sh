#!/bin/bash
THIS=${BASH_SOURCE[0]}
THIS_PATH=$(dirname ${BASH_SOURCE[0]})

mkdir $THIS_PATH/tmp
for file in $THIS_PATH/*.yaml; do
 echo "Processing $file"
 ln -sfn $PWD/$file $THIS_PATH/tmp/student.yaml
 result=$(facter --external-dir=$THIS_PATH/tmp tiad_student)
 if [ "x$result" == "x" ] ; then
  echo "Error with '$file'"
  rm -rf $THIS_PATH/tmp
  exit 2
 fi
 cat << EOF | ruby
test=$result
printf("user=\"%s\" email=\"%s\" message=\"%s\"\n", test['name'], test['email'], test['message'])
EOF
done
rm -rf $THIS_PATH/tmp
