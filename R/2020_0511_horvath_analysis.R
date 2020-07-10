# #------------------------------------------------------------------------------------
# # PACKAGES #
# source("http://bioconductor.org/biocLite.R")
# biocLite(c("GO.db", "preprocessCore", "impute"))
# packages = c("tidyr", "purrr", "stringr", "dplyr", "reshape2", "ggplot2", "gridExtra", "forcats", "pracma", "seqinr", "knitr", "WGCNA", 
#              "matrixStats", "Hmisc", "splines", "foreach",  "fastcluster", "dynamicTreeCut", "survival", "minfi")
# package.check <- lapply(packages, FUN = function(x){
#   if (!require(x, character.only = TRUE)) {
#     install.packages(x, dependencies = TRUE)
#     library(x, character.only = TRUE)
#   }
# })
# install.packages('yaml')
# install.packages('bmphunter')

# if (!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager")

BiocManager::install("minfi")
BiocManager::install("IlluminaHumanMethylationEPICmanifest")
BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19")
library(minfi)
#------------------------------------------------------------------------------------

##Set working directory
baseDir="C:/Users/Nate/Desktop/2020_0305_Horvath_MIDAS_ATV_analysis"
setwd(baseDir)

##Read in sample information
targets=read.csv(paste0(baseDir,"/idatFiles/SampleSheet.csv") ) 

##Define directory of idat files
targets$BasenameOriginal=as.character(targets$Basename)
targets$Slide =substr(targets$Basename,1,12)
targets$Basename=paste0(baseDir,"/idatFiles/",targets$Slide, "/", targets$BasenameOriginal)

##Read idat files
RGset   <- read.metharray.exp(base=NULL, targets = targets,recursive=TRUE, force=TRUE)

##Create Methylation dataset (NOOB background subtraction pre-proprocessing)
Mset <- preprocessNoob(RGset)

##Create Genomeset 
gset <- mapToGenome(Mset)

##Convert to ratios
grset=ratioConvert(gset,what="both")

##Get beta values (Noob prepreprocessed only)
beta_n=getBeta(grset)
data_n=data.frame(ID=row.names(beta_n),beta_n) 

##Write csv of noob data
# write.csv(data_noob, paste("data_noob_", format(Sys.time(), "%Y_%m%d_%H%M%S"), ".csv", sep=""))

##Quantile normalize
quantile.norm=preprocessQuantile(RGset)

##Get beta values (noob and quantile pre-processed)
beta_nq=getBeta(quantile.norm)
data_noob_quantile=data.frame(ID=row.names(beta_nq),beta_nq)

##Write csv of noob pre-processed and quantile normalized data
# write.csv(data_noob_quantile, paste("data_noob_quantile_", format(Sys.time(), "%Y_%m%d_%H%M%S"), ".csv", sep=""))



