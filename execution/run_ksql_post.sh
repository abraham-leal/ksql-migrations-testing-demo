#!/bin/bash
cd "$(dirname "$0")"
cd ..

ksql-migrations apply -c execution/ksql-migrations.properties -a