#!/bin/bash
# runs the kTom workflow
# last_edited: 2021/10/13

### Step 1: Pre-processing
# Reads QA/QC
file_name=ERR418063
dx run fastqc --input "reads=../fastq_84_tomatos/${file_name}_1.fastq.gz" -y

# Trim
dx run flexbar_fastq_read_trimmer -ireads_fastqgz=../fastq_84_tomatos/${file_name}_1.fastq.gz \
 -ireads2_fastqgz=../fastq_84_tomatos/${file_name}_2.fastq.gz \
 -imax_uncalled=4 \
 -itrim_quality_threshold=20 \
 -itrim_left=5 \
 -itrim_right=5 \
 -imin_length=50 -y

### Step 2: Get k-mers
kmersize=21
dx run jellyfish_and_genomescope \
  -isequences_fastx="${file_name}_1_trimmed.fastq.gz" \
  -isequences_fastx="/${file_name}_2_trimmed.fastq.gz" \
  -ioutput_prefix=${file_name}"_mer_count" \
  -imer_length=${kmersize} \
  -ioutput_kmer_counts=TRUE -y
