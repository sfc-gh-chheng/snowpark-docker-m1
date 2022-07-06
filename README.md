# snowpark-docker-m1

docker build . --tag snowpark

docker run -dp 8888:8888 snowpark /bin/bash -c "jupyter-lab --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root"