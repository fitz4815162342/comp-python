# comp-python
Computational Python inside docker

# build image
docker build -t comp-python .

# run image
docker run --name comp-python -p 3838:3838 --env="DISPLAY" -v "$PWD/persistent/notebooks:/home/adrian/notebooks" -d comp-python

and navigate to http://ip:3838
