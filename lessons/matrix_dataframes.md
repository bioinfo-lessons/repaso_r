# Working with tables in R

For the purposes of this lesson, we are not talking about R tables here, which are more specific to the statistic concept of contingency table. Tabular data is usually handled as data frames and matrices. In Bioinformatics, one of the most characteristic matrix is the **count matrix**, which stores geneXsample counts from an RNA-Seq experiment. Similarly, one of the most common data frame you will work with is the experiment data associated with a count matrix. It keeps vital information about an experiment such as which samples belong to which experimental group our how each sample as processed.

## Matrix vs data frame
| Matrix | Data frame |
|:-:|:-:|
|Two dimensional, rectangular array| Multiple data types in multiple columns (fields)|
| Fixed rows and columns | Variable number of rows and columns |
| Column-wise, all ements must be of the same data type | Data can be numeric, character or factor |
| Homogeneous | Heterogeneous |
| Generalized as m*n array | Generalized as a list of vectors of equal length | 
| Memory efficient | Heavy on memory |
| Tuned up for linear algebra | General purpose data bases |

As a curiosity: a lot of R functions on data frames will coerce them to matrix internally as one of the first steps. 

## Coercing a data frame to matrix and the other way around

Coercing a matrix to data frame is straightforward due to data frames being heterogeneous and flexible. To do so, the appropiate function in base R is:

````
as.data.frame(matrix)
````

However, the other way around is not that simple. Create a simple data frame by typing:
````
a <- c('alphabet'=c('alpha', 'beta', 'gamma'), 'arabic'=c(1,2,3))

# Visualize it:
a
````
Our dataframe is now ready. It has two columns called _alphabet_ and _arabic_. If you type:

````
class(a$alphabet)
class(a$arabic)
````
_alphabet_ is a column composed of _factors_ while _arabic_ is a **numeric class** vector.

Before trying to coerce this data frame to a matrix, think for a moment about the differences we talked about earlier, then try to answer the following questions:

1. Can we directly convert _a_ to a matrix? Why?
1. Is there any transformation we could apply before coercing? Which one? Why?

Actually, R will coerce this data frame to a matrix without any warning or system message. Let's try it:

````
b <- as.matrix(a)
````
Examine this matrix carefully. Do you spot what happened? You can also type:

````
class(b[,'alphabet'])
class(b[,'arabic'])
````
These two lines select all rows from each of the columns and then feed the result to the _class_ function. Indeed, our data frame is now a matrix. However, R has coerced our numeric column to a character vector first. Remember that **matrices are homogeneous**, they cannot store mixed data types. 
R silently converted our of our columns to a common data type (in this case, **characters**) before coercing.

Moreover, let's see what happens If we attempt to append another column to our newly created matrix:

````
c <- cbind(b,'more_numbers'=c(4,5,6))
c
````
Here we are **binding a column** (cbind) to our matrix. _more_numbers_ is a **named vector** of equal length, but all of its values are **numeric**. What happened? R successfully appended a column, returning a **new** (remember, matrices have fixed dimensions) matrix with a third column. However,
our new column has been coerced to... you guessed it: **character**.

## Is there any way to predict how R will coerce our columns? 
As by the docs, ```as.matrix()``` returns a character matrix ff there are only atomic columns and any non-(numeric/logical/complex) column. Factors are coerced using ```as.vector()``` and format is used for the rest of non-character columns. Otherwise, R follows a   **coercion hierarchy**, more precisely: complex > double > integer > logical. I.E: all-logical data frames are coerced to all logical matrices, but a mixed logical-integer data frame is coerced to an integer matrix.


## Matrix operations

Remember that in R, matrices are represented by: matrix[rows, columns]. Most of the operations you need to know about involve subsetting, so we will start with some examples. Let's start by creating a matrix, m:

````
m <- matrix(1:80, nrow=8, ncol=10, byrow=TRUE)
````
Our matrix will have 8 rows, 10 columns and their values will range from 1 to 80. The last argument tells R to fill the values row wise. If you are in doubt, change it to ````FALSE```` and see what happens :)

### Retrieving rows an columns by their index

Select the __second__ row, and **all the columns**:
````
m[2, ]
````
Select __all__ rows from the __third column__:
````
m[,3]
````
You can use both of them at the same time:

````
m[1,3]
````
This will return the cell at the intersection of the **first row** and the **third column**

Select rows 6,7,8 and columns 4,5,6:
````
m[6:8,4:6]
````
In this case, by using ```a:b``` we are implicitly creating an atomic vector of integers from a to b, which is then passed to m.

Select all rows but the last one and all the columns:
````
m[-1,]
````

Get **all rows** from the **last** column:
````
m[,ncol(m)]
````
This one is slightly more complex. ```nrow``` and ```ncol``` return how many rows/columns are present in a given matrix or data frame. Basically, we are retrieving the number of columns in m. In R, indexes range from 1:n (those of you coming from C, be ware!) so the total number of rows/columns is also the last row/column. 

## Retrieving rows and columns by names

You may be familiar with column and row names in data frames, but we can also use them for matrices. Moreover, we can subset by named rows and columns too. Let's start by getting and setting the column and row names. They are the same for data frames:

````
rownames(m)
colnames(m)
````
Both return NULL because we haven't named them yet. 

````
rownames(m) <- as.character(1:8)
colnames(m) <- c('A','B','C','D','E','F','G','H','I','J')
````
You may use integers for the row names, but I personally prefer strings for names.

Now, we are ready to subset. 

Select **all rows** from column **A**:
````
m[,'A']
````
Select rows **1,2,3** from columns **F,G**:
```` 
m[c('1','2','3'), c('F','G')]
````
As you can see, subsetting using column and row names is pretty much the same as with indexes.

## Using logical vectors to subset

Finally, we can select rows or columns based on a boolean vector:
````
my_rows <- c(TRUE, rep(FALSE, times=7))
m[my_rows,]
````
Take your time to understand the logic behind this operations. Start by looking up the documentation for ```?rep``` if you are unsure. Do you understand what we did here?

Now try the following:
````
greater_than_11 <- m > 11
greater_than_11
````

Which would be the subset of the following?
````
m[greater_than_11]
````

Try to reason the following questions:

1. Would the following operation fail? ````m[greater_than_11,]````Why?
1. How would you retrieve all cells of the first column whose values are greater than 20?


## Subsetting in data frames
It is actually the same! There are no differences between data frames and matrices when it comes to subsetting. However, data frames do have an additional operator to select columns. We will review it now. Let's start by creating a new data frame:

````
bioinformatics_students <- data.frame(background=c('computational', 'life_sciences', 'other'), name=c('Marta', 'Santiago', 'Pedro'))
````
It has two columns, called **name** and **background**. You can select **all rows** from the column **background** by typing:

````
bioinformatics_students$background 
````

Note that this is the same as typing:
````
## Subset by named columns
bioinformatics_students[,'background']
## Or by index
bioinformatics_students[,1]
````
