# R do's and don'ts

## Project management
### DO
1. Create a new conda environment from each bioinformatics project. You will save yourself a lot of headaches in terms of dependencies.
1. Make a new directory for each project and then, separate code files and raw/processed data in subdirectories. 
1. Export your conda environment once you are finished with the project and save it in the same directory as the project. This way, even
if you delete your environment to clear some disk space, you will have a recipe to make it again if you need to revisit it.
1. Use GIT and some form of hosting for version control such as _GitHub_ or _GitLab_. Keep your code and environment files there, do not upload raw or processed files. If you are shy about lettings other read your bad code, then write good code :). Be nice to future you.
1. Call the libraries and set the working directory at the top of your script. This allows yourself and others to quickly identify dependencies and
your project structure. 
1. Keep file paths relative to your working directory. If you cannot afford to duplicate files between projects, create soft links with `ln -s` to these files and keep the link in the project directoy.

### DO NOT
1. Recycle conda environments between projects to save disk space. As library requirements pile up, the chances of your installation breaking increase too. Moreover, conda is very smart about dependency management, it won't download the same file twice unless it is needed.
1. 

## Working with R

## DO
1. Research the available functions from both base R and the tidyverse. Most of the time, there is a function which just fit your requirements.
1. Read the documentation and vignettes from the libraries you install. Remember that you can invoke the documentation for a single function
by typing a single **?** before the function name. An example for the sum function: ```?sum```
1. Choose meaningful names for objects, variables and functions. Meaningful names should be composed of short descriptions of the stored data. Ideally, variable names should be nouns and function names, verbs. Use underscores if needed, but try to keep the names short. 
1. Write meaningful comments for your code. The key to strive a balance between no comments and too many comments is to ask yourself: _is it obvious what this code does at first glance?_ If the answer is not a clear YES, and If you are already using meaningful names, then write a comment. 
1. Learn ggplot2, the _de facto_ plotting libray. If you can afford it, enroll in a course or two. 

## DO NOT
1. Reinvent the wheel. Research if an available function exists for your task, even If it means intalling another package. This is especially true for
statistical tests, algorithms and data manipulation tasks such as sorting, split apply operations and so on.
1. Recycle variables or redeclare functions after the beginning of the file. Doing so greatly impacts code readability, as variable names no longer indicate which data is stored. Memory is hardly ever an issue these days if the appropiate tools are used. So, please, DONT. 
1. Use complex, nested statements or anonymous functions just for the sake of using them. Remember, readability first. 
1. Use R for every bioinformatics task. Despite its popularity and flexibility, R is not the only language with a strong support for data manipulation and statistics. For instance, Python also features a versatile tabular data library (pandas, which I personally prefer ;) ) and you will find plenty of support for data mining, machine learning and neural networks which in my opinion is lacking in R. 

## Working with data frames and matrices

## DO
1. Choose short, meaningfulnames for columns. Use underscores if needed, avoid whitespaced like the plague.
1. Ensure that each column is a variable and each row, an observation. Each cell should contain a single measure. 
1. Take your time to familiarize yourself with the _tidyverse_. As a bioinformatician, you will spend hundreds of hours dedicated to tyding data. Get to know your tools.

## DO NOT
1. Loop over lists by explicit indexes or dataframe rows. R is fundamentally a vector based language. These loops are not only slow and inneficient, they also defeat the purpose of vectors in the first place. Before looping, ask yourself If you can accomplish the same result using vector operations. Most of the time, an _apply_ is sufficient if you really need to loop. 
1. Dinamically append rows to a dataframe inside a loop. This is slow, inefficient and error prone. Fill a list instead, and once the loop is filled, convert it to a dataframe and concatenate them. 
1. Abuse ````rbind```` or ````cbind```` when working with matrices.  Resist the urge to fill a matrix using a loop. Fill a vector list instead and then coerce it to a matrix. 