#!/usr/bin/bash

export PATH=/usr/local/bin:$PATH

R CMD BATCH --vanilla collect_data.R
R CMD Batch --vanilla combine_data.R
R CMD BATCH --vanilla augment.R
