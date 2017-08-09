FROM fedora:latest
MAINTAINER Dan Sheikh <dan.sheikh@outlook.com>
ENV container docker
ADD ../scripts /var/tmp/scripts
RUN bash /var/tmp/scripts/setup_user.sh
USER dev
ENV HOME /home/dev
RUN mkdir -p /var/www /var/log/httpd /var/log/mysql
RUN dnf -y update
RUN dnf -y groupinstall "Basic Desktop"
RUN dnf -y groupinstall "Development Tools"
RUN dnf -y install curl wget vim postgresql-server postgresql-contrib gcc clang git httpd ack mesa-libGL mesa-libGLU libXrandr mesa-dri-drivers xorg-x11-server-Xorg mongodb tar bzip2 elixir
RUN dnf -y clean all
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm
RUN echo -e 'export NVM_HOME=$HOME/.nvm' >> $HOME/.bashrc
RUN echo -e 'export LD_LIBRARY_PATH="/usr/lib64:$HOME/anaconda3/lib:$LD_LIBRARY_PATH"' >> $HOME/.bashrc
RUN echo -e 'export LD_PRELOAD="/usr/lib64/libstdc++.so.6:$HOME/anaconda3/lib/libmkl_core.so:$HOME/anaconda3/lib/libmkl_sequential.so"' >> $HOME/.bashrc
RUN curl -j -k -L https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh > /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN printf "\nq\nyes\n\n\n" | bash /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN $HOME/anaconda3/bin/conda update anaconda
RUN $HOME/anaconda3/bin/conda install gensim
RUN $HOME/anaconda3/bin/pip install ipdb
RUN bash /var/tmp/scripts/setup_ai.sh
RUN bash /var/tmp/scripts/setup_jvm.sh
RUN echo -e "\$include /etc/inputrc\nset bell-style none" > $HOME/.inputrc
RUN echo -e 'export ANACONDA_HOME=$HOME/anaconda3' >> $HOME/.bashrc
RUN echo -e 'PATH=$ANACONDA_HOME/bin' >> $HOME/.bashrc
RUN echo -e '[ -s $NVM_HOME/nvm.sh ] && . $NVM_HOME/nvm.sh' >> $HOME/.bashrc
RUN bash /var/tmp/scripts/setup_golang.sh
RUN . $HOME/.bashrc
RUN nvm install --lts
RUN rm /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
EXPOSE 80 8000 8080 3306
CMD ["/bin/bash"]
