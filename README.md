# comp-python
Computational Python inside docker

# run 
docker run --name comp-python -p 4815:4815 --env="DISPLAY" -d fitz4815162342/comp-python

If you want to share data from a persistent directory on your host into the volume of the container:

docker run --name comp-python --rm -v $(pwd)/persistent:/home/me/persistent -p 4815:4815 --env="DISPLAY" -d fitz4815162342/comp-python
