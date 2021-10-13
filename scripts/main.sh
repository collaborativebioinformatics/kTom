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
ls ../fastq_84_tomatos/${file_name}_1.fastq.gz ../fastq_84_tomatos/${file_name}_2.fastq.gz | xargs -n 1 echo gunzip -c > generators.txt
jellyfish count -m 21 -s 3300000000 -t 16 -o ERR418122_mer_count.jf \
  -g generators.txt -G 8 --out-counter-len=2 -C
jellyfish histo -t 16 -o ${file_name}_mer_count.csv ${file_name}_mer_count.jf
Rscript genomescope.R ${file_name}_mer_count.csv 21 90 ./ 1000
