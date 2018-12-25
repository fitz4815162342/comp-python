FROM ubuntu:latest

RUN apt-get update && yes|apt-get upgrade && \
    apt-get install -y emacs wget bzip2 git unzip sudo


RUN adduser --disabled-password --gecos '' me
RUN adduser me sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER me
WORKDIR /home/me/
RUN chmod a+rwx /home/me/


# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
RUN rm Anaconda3-5.0.1-Linux-x86_64.sh

# Set path to conda
ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/me/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Install Quantum Information SDK
RUN pip install qiskit numpy scipy scikit-learn pillow h5py tensorflow keras

# Configuring access to Jupyter
RUN mkdir -p /home/me/notebooks

RUN mkdir -p /home/me/persistent && chmod 777 -R /home/me/persistent
VOLUME home/me/persistent

RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/me/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /home/me/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_remote_access = True" >> /home/me/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 4815
EXPOSE 4815

# Run Jupytewr notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/me/notebooks", "--ip='*'", "--port=4815", "--no-browser"]
