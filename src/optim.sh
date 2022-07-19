#!/bin/bash

#SBATCH --job-name=Optimization_tests
#SBATCH --mail-type=NONE
#SBATCH --mail-user=dgomez_ext@iconcologia.net
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4gb
#SBATCH --gpus=quadro
#SBATCH --output=slurm-%j.log

eval "$(conda shell.bash hook)"
conda activate phd 
python -u src/main.py
