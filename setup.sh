#!/bin/bash

ENV_NAME=ce_calibration
CONDA_PATH=`conda info --base`

conda create -n $ENV_NAME -c conda-forge -y --strict-channel-priority --file conda.requirements
source $CONDA_PATH/etc/profile.d/conda.sh
conda activate $ENV_NAME 

pip install trieste
R CMD INSTALL models/r-ceamodel
R CMD build models/lung/lcsimul.dev
R CMD INSTALL models/lung/lcsimul.dev*.tar.gz
