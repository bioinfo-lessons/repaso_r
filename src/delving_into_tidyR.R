library('tidyverse')

setwd('~/cnio_remote/repaso_r/examples/')

## Loading data with readr
ucec  <- readr::read_tsv(file='TCGA.UCEC.maf', skip = 5)

## Filter out low depth variants
low_t_depth <- ucec$t_depth >= 30
low_n_depth <- ucec$n_depth >= 30

ucec <- ucec[low_t_depth & low_n_depth, ]

## Filter intronic variants 
## Start by getting all the possible variants classes in our dataset

## BASE R 
unique(ucec$Variant_Classification)
non_relevant <- c('Silent', 'Intron', "5'Flank", "3'UTR", "5'UTR")

ucec_base <- ucec[!ucec$Variant_Classification %in% non_relevant,]

## DPLYR way
ucec <- ucec %>%
            filter(!Variant_Classification %in% non_relevant)

## Unique tumoral samples ##
length(unique(ucec$Tumor_Sample_Barcode))


## Tumoral depth by sample ##
depth_by_sample <- ucec %>%
                        group_by(Tumor_Sample_Barcode) %>%
                        summarise(n(), mean(t_depth))

