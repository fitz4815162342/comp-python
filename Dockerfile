# We will use Ubuntu for our image
FROM ubuntu:latest

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade && \
    apt-get install -y emacs wget bzip2 git unzip sudo

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' adrian
RUN adduser adrian sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER adrian
WORKDIR /home/adrian/
RUN chmod a+rwx /home/adrian/


# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
RUN rm Anaconda3-5.0.1-Linux-x86_64.sh

# Set path to conda
ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/adrian/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Install Quantum Information SDK
RUN pip install qiskit

# Configuring access to Jupyter
RUN mkdir /home/adrian/notebooks

RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/adrian/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 3838
EXPOSE 3838

# Run Jupytewr notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/adrian/notebooks", "--ip='*'", "--port=3838", "--no-browser"]