#!/usr/bin/env Rscript 

args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args) == 0) {
  stop("The input file must be supplied.", call.=FALSE)
} else if (length(args) > 1) {
  stop("Too many input files! Expecting exactly one.", call.=FALSE)
}

if (!requireNamespace("tidyverse", quietly = TRUE))
  install.packages("tidyverse")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE))
  install.packages(c("ComplexHeatmap", "InteractiveComplexHeatmap"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(ComplexHeatmap)
  library(InteractiveComplexHeatmap)
})

n <- 500
infile <- args[2]

### input data matrix 
# read file
# data wrangling for infile into matrix of int


# plot heatmap
set.seed(123)
kmers_mat <- as.matrix(kmers_df_mod[1:n, !colnames(kmers_df_mod) %in% c("Kmer", "hm_label")])
rownames(kmers_mat) <- kmers_df_mod$hm_label[1:n]
ht1 <- Heatmap(kmers_mat, 
               cluster_columns = FALSE, 
               cluster_rows = FALSE, 
               height = 50,
               name = "Kmers freq1")
ht1 <- draw(ht1)

# generate and save hm shiny app
htShiny(ht1, save = paste0("./", str_replace_all(Sys.Date(), "-", "_"), "_kmer_hm/"))
