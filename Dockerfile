FROM jupyter/minimal-notebook:aarch64-latest

# name your environment and choose python 3.x version
ARG conda_env=snowpark
ARG py_ver=3.8
ARG snowflake_channel=https://repo.anaconda.com/pkgs/snowflake

# you can add additional libraries you want conda to install by listing them below the first line and ending with "&& \"
RUN conda create --quiet --yes -p $CONDA_DIR/envs/$conda_env -c $snowflake_channel python=$py_ver ipython ipykernel && \
    conda clean --all -f -y

# update essentials
USER root
RUN apt-get update && apt-get -y install g++

RUN $CONDA_DIR/envs/${conda_env}/bin/pip install --upgrade pip setuptools wheel

RUN $CONDA_DIR/envs/${conda_env}/bin/pip install numpy pandas scikit-learn streamlit

# create Python 3.x environment and link it to jupyter
RUN $CONDA_DIR/envs/${conda_env}/bin/python -m ipykernel install --user --name=${conda_env} && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH

# if you want this environment to be the default one, uncomment the following line:
ENV CONDA_DEFAULT_ENV ${conda_env}

# The code to run when container is started:
RUN mkdir /opt/notebooks
COPY . /opt/notebooks
WORKDIR /opt/notebooks
RUN $CONDA_DIR/envs/${conda_env}/bin/pip install 'snowflake-snowpark-python[pandas]'

# docker run -dp 8888:8888 snowpark /bin/bash -c "jupyter-lab --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root"
