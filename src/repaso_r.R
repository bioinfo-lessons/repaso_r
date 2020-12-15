library('tidyr')
library('airway')

setwd('~/cnio_remote/repaso_r/')

## Load our dataset
data('airway')

### --------------- SECTION 1: Objects ----------- ###
# ------------------------------------------------- #

## We'll start by getting its object type and investigate it

class(airway)
?RangedSummarizedExperiment
?SummarizedExperiment

## Now that we know what we are dealing with, let's check its assay data.

# We can do it by using the function colData
meta_data <- as.data.frame(colData(airway))

# Or we can retrieve it by acessing the slot directly
meta_data_slot <- as.data.frame(airway@colData)

# Let's get more info, now about the row (genes) ranges.
row_ranges  <- airway@rowRanges
genome_info <- row_ranges@metadata$genomeInfo
genome_info <- as.data.frame(genome_info)

# Finally, we will extract the count matrix
counts <- assay(airway)


### --------------- SECTION 2: Matrices ----------- ###
# ------------------------------------------------- #

# Let's check the dimensions as rows x columns
matrix_size <- dim(counts) 

# Let's see the first ten lines
head(counts, 10)

# Get the number of rows and the row names
number_rows <- nrow(counts)
row_names   <- rownames(counts)

## Subset by index, let's get the first ten rows of the first 3 samples.
## Remember that, in R, indexes start at 1.
counts_subset <- counts[1:10,1:3]

## Now, let's get the first ten rows but keeping all samples (columns)
counts_subset <- counts[1:10,]

# Do you see the comma? We are leaving that field empty, meaning all columns
# get selected

## Now let's get the first 5 rows of all columns but the last one. We are basically
## choosing columns from 1 to 7
counts_last <- counts[1:5, 1:7]

## Let's get all but the first now column. 
counts_last <- counts[1:5, -1]

## Or the second column
counts_last <- counts[1:5, -2]

## EXERCISE 1: How would you remove the last column of a matrix if you don't
## know the dimensions in advance

## Answer
counts_last <- counts[, -ncol(counts)]


## Can we get a row by it's name? Yes. Let's get a particular gene, for instance
## ENSG00000064655 for the first 5 columns

counts_gene <- counts['ENSG00000064655', 1:5]

# Let's add another one: ENSG00000066027
counts_gene <- counts[c('ENSG00000064655', 'ENSG00000066027'), 1:5]

# What happened?

# First, we create an atomic vector of length 2 using the function c
my_genes <- c('ENSG00000064655', 'ENSG00000066027')

## You can check its length with
length(my_genes)

## Now, we can use a vector to subset the matrix
counts_gene <- counts[my_genes, 1:5]

## We can do it across columns too. Let's get SRR1039508 and SRR1039520
my_samples <- c('SRR1039508','SRR1039520')

counts_samples <- counts[,my_samples]

# WOW! we selected all rows. Let's see the first 5
head(counts_samples, 5)
