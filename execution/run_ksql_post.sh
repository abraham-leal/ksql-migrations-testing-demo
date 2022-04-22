#!/bin/bash
cd "$(dirname "$0")"

ksql-migrations apply -c execution/ksql-migrations.properties -a