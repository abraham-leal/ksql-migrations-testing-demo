#!/bin/bash
cd "$(dirname "$0")"

tests=$(ls -d */ | sed 's/\///')

for singleTest in $tests
do 
    ksql-test-runner -i "${singleTest}/${singleTest}_inputs.json" -o "${singleTest}/${singleTest}_outputs.json" -s "${singleTest}/${singleTest}_SQL.ksql"
done 

exit 0