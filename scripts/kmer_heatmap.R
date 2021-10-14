#!/usr/bin/env Rscript 

args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args) == 0) {
  stop("The input file must be supplied.", call.=FALSE)
} else if (length(args) == 2) {
  infile_data <- args[1]
  infile_meta <- args[2]
} else if (length(args) > 2) {
  stop("Too many input files! Expecting exactly two.", call.=FALSE)
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
# placeholder variables for example
infile_data <- "all_freq.txt"
infile_meta <- "filereport_read_run_PRJEB5235_tsv.txt"

### input data matrix 
# read data and metadata file
# data wrangling for infile into matrix of int
data_df <- read_tsv(infile_data, col_select = 1:41)
kmers_df_mod <- data_df %>% 
  mutate(hm_label = paste0("kmer", 1:nrow(data_df))) %>%
  filter(rowMeans(select(., where(is.numeric))) > 0.5*length(data_df)) 

meta_df <- read_tsv(infile_meta) %>%
  select(run_accession, scientific_name) %>%
  filter(run_accession %in% colnames(kmers_df_mod))
meta_df$scientific_name <- as.factor(meta_df$scientific_name)
ann_vec <- meta_df %>% pull(scientific_name)
names(ann_vec) <- meta_df$run_accession
ha <- HeatmapAnnotation(Species = ann_vec)

# plot heatmap
set.seed(123)
kmers_mat <- as.matrix(kmers_df_mod[1:n, !colnames(kmers_df_mod) %in% c("kmer", "hm_label")])
rownames(kmers_mat) <- kmers_df_mod$hm_label[1:n]
ht1 <- Heatmap(kmers_mat, 
               # cluster_columns = FALSE, 
               # cluster_rows = FALSE, 
               height = 50,
               top_annotation = ha,
               name = "Kmers freq1")
ht1 <- draw(ht1)

# generate and save hm shiny app
htShiny(ht1, save = paste0("./", str_replace_all(Sys.Date(), "-", "_"), "_kmer_hm/"))
