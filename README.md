# comp-python
Computational Python inside docker

# build image
docker build -t comp-python .

# run image
docker run --name comp-python -p 3838:3838 --env="DISPLAY" -d fitz4815162342/comp-python
