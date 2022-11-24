#!/bin/bash

for i in {1..1000}
do
  psql postgres://wytnfptx:sXiewFaQYIrTjmoRZtRQSB-Y0bqxZgHL@babar.db.elephantsql.com/wytnfptx -f secondaryDataGeneration.sql
done

