# Install (with conda)

Use `setup.sh` or the following commands:

```bash
conda create -n <env_name> -c conda-forge -y --strict-channel-priority --file conda.requirements
conda activate <env_name>

# Trieste package for bayesian optimization, only available from pip
pip install trieste

# CEAModel package, for endometrium model
R CMD INSTALL models/r-ceamodel

# lcsimul.dev package, for lung model
R CMD build models/lung/lcsimul.dev
R CMD INSTALL lcsimul.dev*.tar.gz
rm lcsimul.dev*.tar.gz
```
