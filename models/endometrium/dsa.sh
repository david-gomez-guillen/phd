#!/bin/bash

#SBATCH --job-name=DSA_endometrium    # Job name
#SBATCH --mail-type=END          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=dgomez_ext@iconcologia.net     # Where to send mail	
#SBATCH --cpus-per-task=6                    # Run on a single CPU
#SBATCH --mem-per-cpu=2gb                     # Job memory request
#SBATCH --output=slurm_%j.log   # Standard output and error log

eval "$(conda shell.bash hook)"
conda activate endometrium 
Rscript main_dsa.R 6
