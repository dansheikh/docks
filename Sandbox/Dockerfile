FROM fedora:latest
MAINTAINER Dan Sheikh <dan.sheikh@outlook.com>
ENV container docker
ADD scripts /var/tmp/scripts
RUN bash /var/tmp/scripts/setup_user.sh
USER dev
ENV HOME /home/dev
RUN mkdir -p /var/www /var/log/httpd /var/log/mysql
RUN dnf -y update
RUN dnf -y groupinstall "Basic Desktop"
RUN dnf -y groupinstall "Development Tools"
RUN dnf -y install curl wget vim mariadb mariadb-server gcc clang git httpd nodejs npm ack mesa-libGL mesa-libGLU libXrandr mesa-dri-drivers xorg-x11-server-Xorg mongodb tar bzip2 elixir
RUN dnf -y clean all
RUN echo -e 'export LD_LIBRARY_PATH="/usr/lib64:$HOME/anaconda3/lib:$LD_LIBRARY_PATH"' >> $HOME/.bashrc
RUN echo -e 'export LD_PRELOAD="/usr/lib64/libstdc++.so.6:$HOME/anaconda3/lib/libmkl_core.so:$HOME/anaconda3/lib/libmkl_sequential.so"' >> $HOME/.bashrc
RUN curl -j -k -L https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh > /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN printf "\nq\nyes\n\n\n" | bash /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN $HOME/anaconda3/bin/conda update anaconda
RUN $HOME/anaconda3/bin/conda install gensim
RUN $HOME/anaconda3/bin/pip install ipdb
RUN bash /var/tmp/scripts/setup_ai.sh
RUN echo -e "\$include /etc/inputrc\nset bell-style none" > $HOME/.inputrc
RUN curl -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm > /var/tmp/jdk-8u121-linux-x64.rpm
RUN curl -j -k -L  http://downloads.lightbend.com/scala/2.12.1/scala-2.12.1.tgz > /var/tmp/scala-2.12.1.tgz 
RUN dnf -y clean all
RUN dnf -y --nogpgcheck install /var/tmp/jdk-8u121-linux-x64.rpm
RUN tar -xzf /var/tmp/scala-2.12.1.tgz -C /usr/local/ && mv /usr/local/scala-2.12.1 /usr/local/scala
RUN echo -e 'export ANACONDA_HOME=$HOME/anaconda3' >> $HOME/.bashrc
RUN echo -e 'export SCALA_HOME=/usr/local/scala' >> $HOME/.bashrc
RUN echo -e 'PATH=$ANACONDA_HOME/bin' >> $HOME/.bashrc
RUN perl -i -pe 's;(^PATH=.*);$1:$SCALA_HOME/bin;' $HOME/.bashrc
RUN rm /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN rm /var/tmp/jdk-8u121-linux-x64.rpm 
RUN rm /var/tmp/scala-2.12.1.tgz
EXPOSE 80 8000 8080 3306
CMD ["/bin/bash"]
