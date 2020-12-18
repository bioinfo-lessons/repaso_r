# Preparations for the lesson

## Clone the repo
First, clone the repo to make a local copy. To do so, open a new terminal and navigate to
the directory where you want to clone the repo. It does not matter where, as long as you
have full permissions. If you are unsure, choose your home directory.

````
git clone --branch master https://gitlab.com/bioinfo-lessons/repaso_r
````

## Install the software
Open a new terminal and navigate to your fresh local copy of the repo. Once there,
go to the _envs_ directory:
````
cd envs
````
 There you will find a conda YAML (**Y**AML **A**in't **M**arkup **L**anguage) called _repasor.yaml._  YAML files are commonly used to distribute conda environments. We can create a new conda environment from this file by typing:
````
conda env create -f repaso.yaml
````
Accept the download when prompted and you are good to go.

## Contents of the environment

We have installed the following R libraries:

1. _Airway_ package: an example _RangedSummarizedExperiment_ object from an RNASeq assay. This library is installed using _bioconductor_ so expect conda to pull other bioconductor libraries such as _biobase_ or _biocgenerics_.
1. The complete _tidyverse_: a collection of R libraries focused on data loading, manipulation, tidying and plotting. Some of the included libraries are _tidyr, dplyr or ggplot2_. These are fully compatible with each other and share a common syntax. They greatly expand R base capabilities. Want to know more? Check [the official website.](https://www.tidyverse.org/)
1. _stringi_, which is a dependency of the above collection but tends to not get pulled when installing the tidyverse. So we are explicitly installing it just in case.
1. R itself. Conda automatically installs the newest version of R compatible with these packages as R itself is a dependency. 

## (Optional) Install Rstudio ##
If you haven't installed it yet, do so now. _Rstudio_ is an IDE (**I**ntegrated **D**evelopment **E**nvironment) which also allows us to explore R objects, visualize graphs and debug scripts on the fly.  **DO NOT** install _Rstudio_ from conda, as you will be pulling an ancient version of the software and its dependencies, which in turn will downgrade your R installation. Install it from the official website instead as a **deb** package.

## Launch Rstudio ##
No matter if you had Rstudio installed already or If you just installed it, we will be launching it from the terminal. By default, Rstudio will search from an installation of R in your path. However, to take advantage of our new conda environment and its isolated R version (along with the libraries), we will be using a _trick_:

1. First, activate your new conda environment with:
```bash
conda activate repasor
```
2. Navigate to your local conda installation. By default, it should be installed on:
```bash
cd ~/miniconda3/
```
The path should be the same if you installed anaconda instead of miniconda.

3. Navigate to conda libs directory:
```bash
cd lib
```
4. Launch rstudio from this terminal by typing:
```bash
rstudio
```

By launching Rstudio from your conda environment, you are taking advantage of conda path magic to redirect Rstudio to the R installation available 
on _repasor_. 

## Why do we launch Rstudio from ~/miniconda/lib?
To prevent this nasty issue:
```R
Error in tools::startDynamicHelp() : internet routines cannot be loaded
```
This error will crash some common bioinformatics libraries such as _tximeta_ and even Rstudio integrated help which we will be using a lot. 

## Isn't it more appropiate to install Rstudio with conda?
Then you would be pulling a really old version of R, which in turn will lock you out of the newest versions of the libraries we will be using for this class. The reason I did not set a specific version of R in the environment was to allow conda to decide on the newest R release which was compatible with the packages included in the YAML file. 


## Test the installed packages
To test our installed libraries, we will load them. Open up a conda terminal and activate your new _repasor_ environment. Then, launch R by typing:
```bash
R
```
We are now on an R command line. To load our installed libraries, type:

```R
library('tidyverse')
library('airway')
```
Carefully read the output of the console after each of the imports. Do not fret about _masking_ warnings, it just means that, by default, a function
is being overrriden by another function of the same name loaded from one of the libraries we have loaded. We can still call overriden functions nonetheless. For instance:

```R
MatrixGenerics::rowMedians
```
Here we are telling R we want to use the function **rowMedians** from the **MatrixGenerics** library even If it has been overriden when loading airway.

[Back to table of contents](../README.md/#table-of-contents)