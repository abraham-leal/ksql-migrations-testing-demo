#!/bin/bash
cd "$(dirname "$0")"

ksql-migrations apply -c ksql-migrations.properties -a