# Install (with conda)

Use `setup.sh` or the following commands:

```bash
conda create -n <env_name> -c conda-forge -y --strict-channel-priority --file <requirements_file>
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

Requirement files are:

- `linux_conda.requirements`: Conda requirements for linux with pinned versions.
- `windows_conda.requirements`: Conda requirements for windows with pinned versions.
- `generic_conda.requirements`: Conda requirements for OS-independent platform with unpinned versions, slower to solve dependencies and possible conflicts may happen eventually.
