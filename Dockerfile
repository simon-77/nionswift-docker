FROM python:3
RUN apt-get update && \
	apt-get install -y xauth && \
	apt-get install -y libqt5widgets5 # required by nionswift for GUI
# Switch from root to "nion" user
RUN useradd -ru 1000 -g users --create-home nion
USER nion
WORKDIR /home/nion
# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
	bash ~/miniconda.sh -b -p $HOME/miniconda
# Install Nion Swift
RUN . ~/miniconda/bin/activate root && \
	conda install -c nion nionswift nionswift-tool
COPY startup.sh .
ENTRYPOINT ["/home/nion/startup.sh"]
