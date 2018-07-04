#!/bin/bash

echo 'Dumping schema (without data) to healthyrivers.sql'
pg_dump -s healthyrivers > ../sql/healthyrivers.sql
