[Back to table of contents](../README.md/#table-of-contents)
# Working with tables in R

For the purposes of this lesson, we are not talking about R tables here, which are more specific to the statistic concept of contingency table. Tabular data is usually handled as data frames and matrices. For instance, one of the most characteristic bioinformatics matrix is the **count matrix**, which stores geneXsample counts from an RNA-Seq experiment. Similarly, one of the most common data frame you will work with is the experiment data associated with a count matrix. It keeps vital information about an experiment such as which samples belong to which experimental group our how each sample as processed. Both are used together in DEG (**D**ifferential **G**ene **E**xpression) which you will be reviewing soon.

## Matrix vs data frame
| Matrix | Data frame |
|:-:|:-:|
|Two dimensional, rectangular array | Multiple data types in multiple columns (fields)|
| Column-wise, all ements must be of the same data type | Data can be numeric, character or factor |
| Homogeneous | Heterogeneous |
| Built as an m*n array | Built as a list of vectors of equal length | 
| Memory efficient | Heavy on memory, not that important with modern computers |
| Tuned up for linear algebra | Used as a general purpose tabular database |

As a curiosity: a lot of R functions on data frames will first coerce them to matrix.


## Matrix operations

Remember that in R, matrices are represented by: matrix[rows, columns]. Most of the operations you need to know about involve subsetting, so we will start with some examples. Let's start by creating a matrix, m:

```R
m <- matrix(1:80, nrow=8, ncol=10, byrow=TRUE)
```
Our matrix will have 8 rows, 10 columns and their values will range from 1 to 80. The last argument tells R to fill the values row wise. If you are in doubt, change it to ````FALSE```` and see what happens.

### Retrieving rows an columns by their index

Select the __second__ row, and **all the columns**:
```R
m[2, ]
```
Select __all__ rows from the __third column__:
```R
m[,3]
```
You can use both of them at the same time:

```R
m[1,3]
```
This will return the cell at the intersection of the **first row** and the **third column**

Select rows 6,7,8 and columns 4,5,6:
```R
m[6:8,4:6]
```
In this case, by using ```a:b``` we are implicitly creating an atomic vector of integers from a to b, which is then passed to m.

Select all rows but the last one and all the columns:
```R
m[-1,]
```

Get **all rows** from the **last** column:
```R
m[,ncol(m)]
```
This one is slightly more complex. ```nrow``` and ```ncol``` return how many rows/columns are present in a given matrix or data frame. Basically, we are retrieving the number of columns in m. In R, indexes range from 1:n (those of you coming from C, be ware!) so the total number of rows/columns is also the last row/column. 

## Retrieving rows and columns by names

You may be familiar with column and row names in data frames, but we can also use them for matrices. Moreover, we can subset by named rows and columns too. Let's start by getting and setting the column and row names. They are the same for data frames:

```R
rownames(m)
colnames(m)
```
Both return NULL because we haven't named them yet. 

```R
rownames(m) <- as.character(1:8)
colnames(m) <- c('A','B','C','D','E','F','G','H','I','J')
```
You may use integers for the row names, but I personally prefer strings for names.

Now, we are ready to subset. 

Select **all rows** from column **A**:
```R
m[,'A']
```
Select rows **1,2,3** from columns **F,G**:
```R
m[c('1','2','3'), c('F','G')]
```
As you can see, subsetting using column and row names is pretty much the same as with indexes.

## Using logical vectors to subset

Finally, we can select rows or columns based on a boolean vector:
```R
my_rows <- c(TRUE, rep(FALSE, times=7))
m[my_rows,]
```
Take your time to understand the logic behind this operations. Start by looking up the documentation for ```?rep``` if you are unsure. Do you understand what we did here?


<details>
  <summary>Answer</summary>

  ````rep```` creates a vector of 7 ````FALSE```` values. We are concatenating this vector with a single ````TRUE```` value to get a length 8 vector.
  Then, we subset our matrix, retrieving rows whose position in the matrix matches a ```TRUE``` position in ````my_rows````. In this case, the only ````TRUE````value in ````my_rows```` is the first one, so only the **first** row of ````m```` is retrieved.

</details>


Now try the following:
```R
greater_than_11 <- m > 11
greater_than_11
```

Which would be the subset of the following?
```R
m[greater_than_11]
```

Try to reason the following questions:

1. Would the following operation fail? ````m[greater_than_11,]````Why?
1. How would you retrieve all cells of the first column whose values are greater than 20?

<details>
  <summary>Answers</summary>

  1. greater_than_11 is a boolean matrix, not a vector. To subset with a boolean matrix, the answer is: 
  ```R
  m[greater_than_11]
  ```
  2. To retrieve all cells of the first column with values greater than 20:
  ```R
  above_20 <- m[,1] > 20
  ```

</details>


## Appending rows or columns
To add a new row to a matrix, type:

```R
m <- rbind(m, 81:89)
```
````rbind```` returns a new matrix with a new row, whose values range from 81 to 89. We then assign the result back to m.

To append a new **column** instead, use ```cbind```


## Subsetting in data frames
It is actually the same! There are no differences between data frames and matrices when it comes to subsetting. However, data frames do have an additional operator to select columns. We will review it now. Let's start by creating a new data frame:

```R
bioinformatics_students <- data.frame(background=c('computational', 'life_sciences', 'other'), name=c('Marta', 'Santiago', 'Pedro'))
```
It has two columns, called **name** and **background**. You can select **all rows** from the column **background** by typing:

```R
bioinformatics_students$background 
```

Note that this is the same as typing:
```R
## Subset by named columns
bioinformatics_students[,'background']
## Or by index
bioinformatics_students[,1]
```

## Adding new rows and columns in a data frame

A data frame in R is essentially a list of vectors of equal length. To append a new column, you can either:

```R
bioinformatics_students[, 'grades'] <- c(8,9,10)
```

or 

```R
bioinformatics_students$grades <- c(8,9,10)
```

However, what happens If our new column is **shorter** than the rest? Try to append a vector of length 1 by typing:

```R
bioinformatics_students[,'grade_threshold'] <- 5
```

**What have just happened? Why?** To answer this question, try the following:

```R
bioinformatics_students[,'previous_salary'] <- c(25000,0)
```
It seems that R does not allow us to append our new column, as it is one element shorter than the rest of them.

However, If we add another student like this:

```R
bioinformatics_students[4,] <- c('computational', 'Ana', 10, 5)
```
 
and then try again to append our *previous_salary*:

```R
bioinformatics_students[,'previous_salary'] <- c(25000,0)
```
**It does work! Why?** Think about it for a minute and try to answer it on your own. They keyword here is **recycling**.


<details>
  <summary>Answer</summary>

  For data frames, partial vector recycling will fail. For our three students, attempting to recycle a vector of length 2 will fail because we would have to recycle a single element of the shorter vector. The class ````data.frame```` will only recycle a vector a **whole** number of times. Since any number can be divided by 1, assigning a single value to a new column will always succeed. The same happens when we have 4 students instead of 3 as 4/2 returns a whole number.

</details>

## Coercing a data frame to matrix and the other way around

Coercing a matrix to data frame is straightforward due to data frames being heterogeneous and flexible. To do so, the appropiate function in base R is:

```R
as.data.frame(matrix)
```

However, the other way around is not that simple. Create a simple data frame by typing:

```R
a <- data.frame('alphabet'=c('alpha', 'beta', 'gamma'), 'arabic'=c(1,2,3))

# Visualize it:
a
```
Our dataframe is now ready. It has two columns called _alphabet_ and _arabic_. If you type:

```R
class(a$alphabet)
class(a$arabic)
```
_alphabet_ is a column composed of _factors_ while _arabic_ is a **numeric class** vector.

Before trying to coerce this data frame to a matrix, think for a moment about the differences we talked about earlier, then try to answer the following questions:

1. Can we directly convert _a_ to a matrix? Why?
1. Is there any transformation we could apply before coercing? Which one? Why?

<details>
  <summary>Answer</summary>

  1. No, because matrices are homogeneous and our data frame has columns of differing data types.
  1. We should first coerce one of our matrix vector. Our second column is made up of integers, which can be coerced to characters to match our first column, alphabet.

</details>

Actually, R will coerce this data frame to a matrix without any warning or system message. Let's try it:

```R
b <- as.matrix(a)
```
Examine this matrix carefully. Do you spot what happened? You can also type:

```R
class(b[,'alphabet'])
class(b[,'arabic'])
```
These two lines select all rows from each of the columns and then feed the result to the _class_ function. Indeed, our data frame is now a matrix. However, R has coerced our numeric column to a character vector first. Remember that **matrices are homogeneous**, they cannot store mixed data types. 
R silently converted our of our columns to a common data type (in this case, **characters**) before coercing.

Moreover, let's see what happens If we attempt to append another column to our newly created matrix:

```R
c <- cbind(b,'more_numbers'=c(4,5,6))
c
```
Here we are **binding a column** (cbind) to our matrix. _more_numbers_ is a **named vector** of equal length, but all of its values are **numeric**. What happened? R successfully appended a column, returning a **new** (remember, matrices have fixed dimensions) matrix with a third column. However,
our new column has been coerced to... you guessed it: **character**.

## Is there any way to predict how R will coerce our columns? 
As by the docs, ```as.matrix()``` returns a character matrix ff there are only atomic columns and any non-(numeric/logical/complex) column. Factors are coerced using ```as.vector()``` and format is used for the rest of non-character columns. Otherwise, R follows a   **coercion hierarchy**, more precisely: complex > double > integer > logical. I.E: all-logical data frames are coerced to all logical matrices, but a mixed logical-integer data frame is coerced to an integer matrix.


[Back to table of contents](../README.md/#table-of-contents)