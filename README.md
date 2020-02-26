# rRPMM

R package to download and parse RPMM's metadata from RIKEN Plant Metabolome 
Metadatabase (). This package is new and likely has bugs due to unexpected 
structures of some meta-data format. Please report bugs.

It will pull a list of Studies/Projects from MetabolomeXchange but only RPMM's 
Projects are supported for pulling the data.

## Installation
Install the devtools package and run:

```r
install.packages("devtools")
devtools::install_git(""https://gitxxxxxxxxxxxxxxxxxxxxxxxxxx.git"")

```
## Example

### Download a list of studies with Arabidopsis

```r
library(rRPMM)
data_table <- RPMM_get_projects_list(taxonid = 3702) ## Arabidopsis
```



### Getting URIs of all the raw data files in a Project from RPMM

```r
res <- RPMM_get_rawdata_files(project = "RPMM0001")
```

### License

The rRPMM package is free software; [a copy of the GNU General Public License, version 3](http://www.r-project.org/Licenses/GPL-3)
