#!/bin/bash
# runs the kTom workflow
# last_edited: 2021/10/13

### Step 1: Pre-processing
# Reads QA/QC
file_name=ERR418063
fastqc "reads=../fastq_84_tomatos/${file_name}_1.fastq.gz"

# Trim
flexbar -r ../fastq_84_tomatos/${file_name}_1.fastq.gz \
  -p ../fastq_84_tomatos/${file_name}_2.fastq.gz \
  --max_uncalled 4 \
  --qtrim 20 -x 5 -y 5 \
  --min-read-length 50

### Step 2: Get k-mers
kmersize=21
