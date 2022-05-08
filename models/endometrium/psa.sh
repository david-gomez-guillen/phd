#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Use: psa.sh <n_cores>"
    exit
fi

echo "#!/bin/bash

#SBATCH --job-name=PSA_endometrium              # Job name
#SBATCH --mail-type=END                         # Mail events (NONE, BEGIN, END, FAIL, ALL, ...)
#SBATCH --cpus-per-task=$1                      # Number of CPUs
#SBATCH --mem-per-cpu=4gb                       # Job memory request
#SBATCH --output=slurm_%j.log                   # Standard output and error log

Rscript main_psa.R $1
" > psa_gen.sh

chmod u+x psa_gen.sh

sbatch psa_gen.sh