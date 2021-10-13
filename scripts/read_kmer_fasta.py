#!/usr/bin/env python

accesstion_list= ["ERR418039","ERR418040","ERR418041","ERR418042","ERR418043","ERR418044"]

kmer_all=[]
for accession in accesstion_list:
    fasta_kmer_name= accession+"_kmer_count.fasta"

    f = open(fasta_kmer_name, "r")
    kmer_list=[]
    for line in f:
        line_split=line.strip()
        if line_split[0] == '>':
            freq_kmer=int(line_split[1:])  
        else:
            kmer_list.append(line_split)

    f.close()

    kmer_all.append(kmer_list)

    
kmer_set_all=set()
for kmer_list in kmer_all:
    kmer_set_all = kmer_set_all & set(kmer_list)

    
presense_absence_matrix=[]

for kmer in kmer_set_all:
    presense_absence_perAcc=[]
    for kmer_list_perAcc in kmer_all:
        if kmer in kmer_list_per_acc:
            presense_absence_perAcc.append(1)
        else:
            presense_absence_perAcc.append(0)
            
    presense_absence_matrix.append(presense_absence_perAcc)
    
    