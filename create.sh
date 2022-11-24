#!/bin/bash

psql postgres://wytnfptx:sXiewFaQYIrTjmoRZtRQSB-Y0bqxZgHL@babar.db.elephantsql.com/wytnfptx -f ./tableCreation/table_creation.sql
psql postgres://wytnfptx:sXiewFaQYIrTjmoRZtRQSB-Y0bqxZgHL@babar.db.elephantsql.com/wytnfptx -f ./triggers.sql
psql postgres://wytnfptx:sXiewFaQYIrTjmoRZtRQSB-Y0bqxZgHL@babar.db.elephantsql.com/wytnfptx -f ./dataGeneration.sql

