.PHONY: env clean-env deps lint format mypy test clean-test data clean-data clean-notebook clean

help:
	@echo "           env - Create local environment with Conda or venv : $(PWD)/env"
	@echo "     clean-env - Delete environment"
	@echo "          deps - Install Python Dependencies with Mamba, Conda or pip"
	@echo "          lint - Lint using flake8"
	@echo "        format - Format using black"
	@echo "          mypy - Type check using mypy"
	@echo "          test - Test and produce coverage report using pytest"
	@echo "    clean-test - Delete test files"
	@echo "          data - Download and process dataset"
	@echo "    clean-data - Delete data files"
	@echo "clean-notebook - Remove Notebooks outputs"


#################################################################################
# GLOBALS                                                                       #
#################################################################################

ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
endif

ifeq (,$(shell which mamba))
HAS_MAMBA=False
else
HAS_MAMBA=True
endif

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Create local environment with Conda or venv
env:
ifeq (True,$(HAS_CONDA))
	@echo ">>> Detected Conda, creating Conda environment."
	conda create --prefix $(PWD)/env
	@echo ">>> New Conda environment created : $(PWD)/env . Activate with : \
	conda activate $(PWD)/env"
else
	@echo ">>> Creating venv environment."
	python -m venv env
	source env/bin/activate
	@echo ">>> New venv environment created : $(PWD)/env. Activate with : \
	source env/bin/activate"
endif

## Delete environment files
clean-env:
	rm -rf $(PWD)/env

## Install Python Dependencies with Mamba, Conda or pip
deps:
ifeq (True,$(HAS_MAMBA))
	@echo ">>> Detected Mamba, installing dependancies with Mamba."
	mamba env update -f environment.yml
	@echo ">>> Dependancies installed with Mamba."
else ifeq (True,$(HAS_CONDA))
	@echo ">>> Detected Conda, installing dependancies with Conda."
	conda env update -f environment.yml
	@echo ">>> Dependancies installed with Conda."
else
	@echo ">>> Installing dependancies with pip."
	pip install -r requirements.txt
	@echo ">>> Dependancies installed with pip."
endif

	jupyter labextension install jupyterlab-plotly

## Lint using flake8
lint:
	flake8 src/ tests/

## Format using black
format:
	black src/ tests/

## Type check using mypy
mypy:
	mypy src/ tests/

## Test and produce coverage report using pytest
test:
	pytest --cov=src/ --cov-report=xml:cobertura.xml tests/

## Delete test files
clean-test:
	rm -rf .pytest_cache .coverage cobertura.xml

## Download and process dataset
data:
	python src/data/make_dataset.py data/raw data/processed

## Delete data files
clean-data:
	find ./data/ -type f -not -name ".gitignore" -delete

## Remove Notebooks outputs
clean-notebook: notebooks/notebook.ipynb
	cp notebooks/notebook.ipynb notebooks/notebook-compiled.ipynb
	jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace notebooks/notebook.ipynb

## Clean all
clean: clean-env clean-test clean-data clean-notebook
