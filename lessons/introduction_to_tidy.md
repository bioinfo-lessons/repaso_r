# Introduction to the tidyverse

Base R' implementation of data frames and matrix provides us with a barebones set of tools to work with tabular data. However,a lot of real world problems involving data frames and matrices are cumbersome to solve without some additional packages.

Consider the following table: 

| Student | Courses |
|:----:|:---:|
| Pedro | Math-English-French|
| Marta | Computer_science-Math-Biology|

Our first column is composed of student names. Each cell represents a unique observation. However, the column **courses** contains multiple courses
separated by '-'. Moreover, we also have '_' as a substitute for whitespaces. We are looking at what we call **untidy** data. We could tidy this column in base R, but it we would have to write quite a bit of commands. In this lesson, we are going to harness the power of the _tidyverse_ to allow us to solve this problem and many more effortlessly. 

## The purpose of the tidyverse
The _tidyverse_ is a collection of R libraries for data science. They share a common grammar, structure and design philosophy.  Moreover, they greatly simplify problems that are difficult to tackle in base R. For instance, the above table could be _tidied up_ using two functions only. 

## Tidy vs untidy data

## Diving into the tidyverse

## Reading data
The _tidyverse_ includes libraries ranging from reading data from files to plotting beautiful graphics with _ggplot2_. We are going to delve into
the collection using public somatic alterations data from The Cancer Genome Atlas (TCGA).  More precisely, we are going to work with _uterine carcinosarcoma_ samples. Navigate to the _examples_ directory in this repository and unzip the contests of *table_examples.zip* there. 

Before firing up R, we are going to take a peek at our table:
````
head TCGA.UCEC.maf -n 10
````

Try to answer the following questions:

1. Is this really a tabular file? If so. How are values separated?
1. Which line contains the column names?
1. What does the line before the column names represent?


Now, we are ready to start our analysis in R. Open Rstudio, create a new script and load the whole tidyverse. Change the working directory to where you have stored our mock table.

````
library('tidyverse')
setwd('<your_repo_copy>/examples')
````

Instead of the base R function ````read.csv```` we are going to start using the _tidyverse_ right away. The library _readr_ (**R**ead **r**ectangular) posess various data parsers with are considerably faster and more flexible. 

## Exercise 1: parsing the table
Load the data so that you get a data frame of **120** columns. The first one should be called **Hugo_Symbol**. To guide you through all the functions available in _readr_, remember the questions we previously answered about the data. Take into account that the **C** in **CSV** stands for **comma**. Which separator does our file use? Do not hesitate yo use the library's documentation. Get yourself accustomed to reading and understanding your functions. It will save you thousands of Google queries.

## Exercise 2: understanding our data
Take a look at the column names.  What does each row represent? If you had to choose a single column as the index, which would you choose? 

## Exercise 3: Filtering low quality variants.
Some of the regions sequenced had a low tumoral depth, that is: there are few reads from that region originating in tumoral samples. As such, we cannot really trust the variant. Moreover, we need sufficient normal depth too, because somatic variants are called by filtering out alterations already present in a matched normal sample. 

Filter (remove) variants whose tumoral depth or normal depth was below 30. Start by finding the right columns and then **subset** the data frame using logical vectors as we reviewed.

## Exercise 4: Filtering non functional variants
Some of the variants may not be functionally relevant. Start by retrieving all the **unique** values in the column ```Variant_Classification```. Then, remove those falling in one of the following categories:

````
'Silent', 'Intron', "5'Flank", "3'UTR", "5'UTR"
````
Save the filtered data frame as **base_ucec**. 

As a tip for this exercise, take into account that the expression:
````
animals <- c('crocodile', 'cat', 'salamander')
reptiles <- c('salamander', 'alligator', 'crocodile', 'diplodocus')

reptile_animals <- animals %in% reptiles
````
will return **a boolean** vector of length 3, which is the same as animals. The first value will be **TRUE** if the first value in **animals** appears in reptiles. Otherwise, it will be **FALSE**.

## Filtering, the tidy way
We have filtered our data using base R. Now, we are going to perform the same filtering step using _dplyr_ a powerful library of the _tidyverse._ The best way to understand _dplyr_ is to look at how our filtering would look like with _dplyr_.

````
non_relevant <- c('Silent', 'Intron', "5'Flank", "3'UTR", "5'UTR")

ucec <- ucec %>%
            filter(!Variant_Classification %in% non_relevant)
````
Take a moment and try to guess what this piece of code is doing. 



Ok, let's go through this piece of code line by line:

````
non_relevant <- c('Silent', 'Intron', "5'Flank", "3'UTR", "5'UTR")
````
Here we are defining a vector of values from the column *Variant_Classification* which we want to filter out from our data frame. 

````
ucec <- ucec %>%
````

Here we are assigning **ucec** to **ucec**... or are we? Look at `%>%'. It is _dplyr's pipe operator_. For those unfamiliar with Unix's pipes, this expression tells R that the next function will be applied to our **ucec** data frame. When using _dplyr_ pipes, make sure to **always** start a new line **after** the operator. RStudio should be smart enough to indent the line for you. 

````
filter(!Variant_Classification %in% non_relevant)
````
This line is self explanatory. We are **filtering** our data frame. Have you noticed the ````!````? It is a boolean **operator**, which you can read ad **NOT**. Basically, we are keeping rows where the column **Variant_classification** is not ````%in%```` non_relevant. 

Have you noticed that we have written **Variant_classification** without quoting? That's because by writing:

````
ucec %>%
````
_dplyr_ immediately knows that we are going to operate on the data frame _ucec_ and its columns. Keep this detail in mind, because you will surely encounter it again when you start plotting graphics in **ggplot2**. 


## Group-wise operations with group_by

Before learning about ````group_by````, perform the following exercise:

## Exercise 4
How many **unique** tumor samples do we have right now?

Now, we are going to calculate the **mean tumoral depth of all the variants** by **sample**. In other words, we need to divide our data frame into groups, each being one sample. Then, we have to sum the total tumoral depth of all variants and divide it by the amount of said variants. This is certainly achievable with base R, but with _dplyr_ It becomes trivial. Our key function here is **group_by**.

Here is the snippet: 

````
depth_by_sample <- ucec %>%
                        group_by(Tumor_Sample_Barcode) %>%
                        summarise(n(), mean(t_depth))
````
As before, try to guess what this pipe does before actually running it. Call the documentation to assist you. 

**Group by** operations are really prevalent in Bioinformatics. Remember that the sole purpose of _factors_ is to encode _conditions_ or _states_. Some of you may have thought about _loops_ already, _specially_ if you come from a computational background. However, loops are usually ineficcient, slow and defeat the purpose of vectors operations in the first place.

````
group_by(Tumor_Sample_Barcode)
````
This is the first step of our pipe. It basically splits our data frame in groups sharing the same *Tumor_Sample_Barcode*.
