#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=10:00:00
#SBATCH --output=out/sesameMS.out
#SBATCH --job-name="sesame"
#SBATCH --mail-user=danev1@gmail.com
#SBATCH --mail-type=ALL
#SBATCH -p evanslab


cd $SLURM_SUBMIT_DIR

hostname
module unload R
module load R/4.1.0_gcc-8.3.0

Rscript -e "rmarkdown::render('sesameMS.Rmd')"

module unload R/4.1.0_gcc-8.3.0
module load R

