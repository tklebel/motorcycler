#!/usr/bin/bash

export PATH=/usr/local/bin:$PATH

R CMD BATCH --vanilla collect_data.R
