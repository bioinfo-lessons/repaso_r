[Back to table of contents](../README.md/#table-of-contents)

# Introduction to the tidyverse

Base R's implementation of data frames and matrices provides us with a limited set of tools to work with tabular data. A lot of real world problems involving data frames and matrices are cumbersome to solve without some additional packages. In this lesson, we are going to familiarize ourselves with the collection of libraries which compose the _tidyverse_.

## The purpose of the tidyverse
The _tidyverse_ is a collection of R libraries for data science. They share a common grammar, structure and design philosophy.  Moreover, they greatly simplify problems that are difficult to tackle in base R. 

Consider the following table: 

| Student | Courses |
|:----:|:---:|
| Pedro | Math-English-French|
| Marta | Computer_science-Math-Biology|

Our first column is composed of student names. Each cell represents a unique observation. However, the column **courses** contains multiple courses
separated by '-'. Moreover, we also have '_' as a substitute for whitespaces. We are looking at what we call **untidy** data. We could tidy this column in base R, but it we would have to write quite a bit of commands. On the other hand, the above table can be _tidied up_ with just two functions from the _tidyverse_.

## Tidy vs untidy data

Bioinformaticians and data scientists expend a significant amount of time working on raw data to prepare it for the actual analysis. Often, we receive experimental data gathered in an _excel_ file or as dump from some kind of database. Common flaws in this kind of data are:

* Column headers as values
* Multiple variables stored in a single column
* Variables spread across rows and columns

The concepts behind tidy data were described in “Tidy Data” by Hadley Wickham.[1] He describes three fundamental attributes of tidy data:

1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table


## Hands-On: An untidy example

Create the following data frame:
````
messy <- data.frame(
  name = c("Sandra", "Alfredo", "Laura"),
  a = c(63, 78, 64),
  b = c(56, 90, 50)
)
````
This data frame represents the heartrate of three different patients while treated with two drugs: a and b. Before fixing it, **think about why it is broken.** Try to remember the key concepts of clean data and apply them to this data frame.

To untangle out data, we are going to learn our first _tidy_ function: ````gather````, from the _tidy_ package. 

````
fixed <- gather(messy, 'drug', 'heartrate', a:b)
````
Note that I am not quoting the column names of *messy* here. 

**What does ````gather()```` do?**

````gather()```` takes multiple columns, and gathers them into key-value pairs: it makes “wide” data longer. Another alternative for ````gather```` is ````melt```` from the library _reshape2_. This transformation is also called _pivot_ (spreadsheets) and _fold_ (databases). 


## Separating columns

Now we are ready to tackle the example we reviewed at the beginning of this lesson.
````
today_courses <- data.frame('student'=c('Pedro','Marta'), 'subjects'=c('Math-English-French', 'Computer_science-Math-Biology'))
```` 
We have two students, each with 3 subjects. The order of the subjects is important, so we have to preserve it somehow while cleaning our data. 
First, we are going to **separate** our _subjects_ column into three distinct columns.

````
today_courses <- separate(today_courses, col=subjects, sep='-', into=c('subject_1','subject_2','subject_3'))
````
With ````separate```` we are splitting the **col** _subjects_ by the **separator** _"-"_ **into** three distinct columns called *subject_1, subject_2, subject_3*. 

**Are we done yet?** No, the variable representing **the subject order** is still **spread across three columns**. We have to **gather** it.

````
today_courses <- gather(today_courses, order, subject, subject_1:subject_3)
````

You surely agree with me that *subject_1* does not  clearly represent subjects order. So, as a final step:

````
today_courses$order <- gsub(pattern='subject_', replacement='', fixed=TRUE, x=today_courses$order)
````

Here we are using _gsub_, to replace a **pattern** with a **replacement** string. In our case, *subject_* is replaced with an empty character. ````fixed=TRUE```` tells ````gsub```` to match the string **as is** instead of considering it a **regular expression**. There are multiples ways to achieve the same results, but I find ````gsub```` to be fast and comfortable for this task.


## Beyond data tidying: data analysis, the tidy way.

## Reading data
The _tidyverse_ includes libraries ranging from reading data from files to plotting beautiful graphics with _ggplot2_. Now that we understand the basics of data reshaping, we are going to analyze a dataset of somatic alterations from _uterine carcinosarcoma_ samples, part of The Cancer Genome Atlas (TCGA). Navigate to the _examples_ directory in this repository and unzip the contests of *table_examples.zip* there. 

Before parsing it in R, take a peek at the table with **bash**:
````
head TCGA.UCEC.maf -n 10
````

Try to answer the following questions:

1. Is this really a tabular file? If so. How are values separated?
1. Which line contains the column names?
1. What does the line before the column names represent?


Now, we are ready to start our analysis in R. R offers ````read.csv```` as a general purpose wrapper for _comma separated files_. The library _readr_ (**R**ead **r**ectangular) posess various data parsers with are considerably faster and more flexible. 

## Exercise 1: parsing the table
Load the data so that you get a data frame of **120** columns. The first one should be called **Hugo_Symbol**. To guide you through all the functions available in _readr_, remember the questions we previously answered about the data. Take into account that the **C** in **CSV** stands for **comma**. Which separator does our file use? Do not hesitate yo use the library's documentation. Get yourself accustomed to reading and understanding your functions. It will save you thousands of Google queries.

<details>
  <summary>Answer</summary>

  ucec  <- readr::read_tsv(file='TCGA.UCEC.maf', skip = 5)
</details>


## Exercise 2: understanding our data
Take a look at the column names.  What does each row represent? If you had to choose a single column as the index, which would you choose? 

<details>
  <summary>Answer</summary>
  Each column contains data about a given somatic variant. Each row is a unique somatic alteration. Data frame indexes cannot contain duplicates, and in this case, the default index representing the total amount of variants present in this project is sufficient. 
</details>

## Exercise 3: Filtering low quality variants.
Some of the regions sequenced had a low tumoral depth, that is: there are few reads from that region originating in tumoral samples. As such, we cannot really trust the variant. Moreover, we need sufficient normal depth too, because somatic variants are called by filtering out alterations already present in a matched normal sample. 

Filter (remove) variants whose tumoral depth or normal depth was below 30. Start by finding the right columns and then **subset** the data frame using logical vectors as we reviewed.

<details>
  <summary>Answer</summary>
low_t_depth <- ucec$t_depth >= 30
low_n_depth <- ucec$n_depth >= 30

ucec <- ucec[low_t_depth & low_n_depth, ]
</details>


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

<details>
  <summary>Answer</summary>
unique(ucec$Variant_Classification)
non_relevant <- c('Silent', 'Intron', "5'Flank", "3'UTR", "5'UTR")

ucec_base <- ucec[!ucec$Variant_Classification %in% non_relevant,]
</details>

## Filtering, the tidy way
We have filtered our data using base R. Now, we are going to perform the same filtering step using _dplyr_, a powerful library of the _tidyverse._ The best way to understand _dplyr_ is to look at how our filtering would look like with _dplyr_.

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

Here we are assigning **ucec** to **ucec**... or are we? Look at ````%>%````. It is _dplyr's pipe operator_. For those unfamiliar with Unix's pipes, this expression tells R that the next function will be applied to our **ucec** data frame. When using _dplyr_ pipes, make sure to **always** start a new line **after** the operator. RStudio should be smart enough to indent the line for you. 

````
filter(!Variant_Classification %in% non_relevant)
````
This line is self explanatory. We are **filtering** our data frame. Have you noticed the ````!````? It is a boolean **operator**, which you can read ad **NOT**. Basically, we are keeping rows where the column **Variant_classification** is not ````%in%```` non_relevant. 

Have you noticed that we have written **Variant_classification** without quoting? That's because by writing:

````
ucec %>%
````
_dplyr_ immediately knows that we are going to operate on the data frame _ucec_ and its columns. Keep this detail in mind, because you will surely encounter it again when you start plotting graphics in **ggplot2**. 


## Exercise 5
Do you remember our *today_courses* data frame. All of the functions we applied: _separate, gather..._ can be coded as a single pipe.

<details>
  <summary>Answer</summary>
tidy_courses <- today_courses %>%
                separate(col = subjects, into = c('subject_1', 'subject_2', 'subject_3'), sep = '-') %>%
                gather(order, subjects, subject_1:subject_3)
</details>

## Group-wise operations with group_by

Before learning about ````group_by````, perform the following exercise:

## Exercise 6
How many **unique** tumor samples do we have right now?

<details>
  <summary>Answer</summary>
  2
</details>

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

````
summarise(n(), mean(t_depth))
````
This functions creates a new data frame with one column for each grouping variable and summary statistics. So, we are grouping by *Tumor_Sample_Barcode* and then, for each of these groups, we are calculating ````n()```` which is the number of observations, and the
average *t_depth* for each group. 


## Exercise 7
For each **tumor sample**, report:

1. The **standard deviation** of *t_depth*.
1. The **standard deviation** of *n_depth*.
1. How many **unique** types of **variants** are present in **each tumor sample.**


<details>
  <summary>Answer</summary>
  ```R
patients_standard_deviation  <- depth_by_sample <- ucec %>%
                                group_by(Tumor_Sample_Barcode) %>%
                                summarise(length(unique(Variant_Classification)), sd(c(n_depth)), sd(t_depth))
  ```
</details>


## Closing surprise for those ahead of the rest

Write the following code:

````
## Just in case, load these, even If they are part of the tidyverse
library('ggplot2')
library('scales')
alterations_by_sample <- ggplot(data=ucec, aes(x=Tumor_Sample_Barcode))+
                         geom_bar(aes(y = (..count..)/sum(..count..), fill=Variant_Classification))+
                         scale_y_continuous(labels=percent) +
                         labs(title='Distribution of somatic alterations', x='Tumor sample', y='% of total alterations', fill='Variant  class')+
                         theme_bw()+
                         theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
````

Now, type:

````
alterations_by_sample
````

If you feel curious, try to understand the layered structure of this plot. 



[Back to table of contents](../README.md/#table-of-contents)


## References
1. Wickham, Hadley. 2014. Tidy Data. Journal of Statistical Software; Vol 59; Issue 10.
