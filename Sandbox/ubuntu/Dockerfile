FROM ubuntu:latest
MAINTAINER Dan Sheikh <dan.sheikh@outlook.com>
ENV container docker
ADD scripts /var/tmp/scripts
# RUN bash /var/tmp/scripts/setup_user.sh
RUN groupadd -r dev -g 1000 && useradd -u 1000 -r -g dev -m -d /home/dev -s /sbin/nologin dev && chmod 755 /home/dev
ENV HOME /home/dev
RUN mkdir -p /var/www /var/log/httpd /var/log/postgresql
RUN apt update -y && apt upgrade -y
RUN apt install -y build-essential
RUN apt install -y curl wget vim gcc clang git apache2 php7.0 php7.0-pgsql libapache2-mod-php postgresql postgresql-client postgresql-contrib phppgadmin supervisor ack-grep mongodb tar bzip2 zip unzip locales locales-all
RUN apt clean all -y

# Locale Setup
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Custom User Setup
USER dev
RUN mkdir -p $HOME/bin
RUN touch $HOME/.bashrc
RUN /bin/echo -e 'export TERM=xterm' >> $HOME/.bashrc
RUN /bin/echo -e 'export PATH=$PATH' >> $HOME/.bashrc

# Linuxbrew Setup
RUN git clone  https://github.com/Linuxbrew/brew.git $HOME/.linuxbrew && \
/bin/echo -e 'export BREW_HOME=/home/dev/.linuxbrew' >> $HOME/.bashrc && \
/bin/echo -e 'export MANPATH="$(brew --prefix)/share/man/:$MANPATH"' >> $HOME/.bashrc && \
/bin/echo -e 'export INFOPATH="$(brew --prefix)/share/info/:$INFOPATH"' >> $HOME/.bashrc && \
perl -i -pe 's;^export PATH=(.*);export PATH=\$BREW_HOME/bin:$1;' $HOME/.bashrc

# Perl Setup
RUN /home/dev/.linuxbrew/bin/brew install rakudo-star

# Root User
USER root

# NVM Setup
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm
RUN /bin/echo -e 'export NVM_HOME=$HOME/.nvm' >> $HOME/.bashrc
RUN /bin/echo -e '[ -s $NVM_HOME/nvm.sh ] && . $NVM_HOME/nvm.sh' >> $HOME/.bashrc
RUN /bin/echo -e '[ -s $NVM_HOME/bash_completion ] && . $NVM_HOME/bash_completion' >> $HOME/.bashrc
RUN . $HOME/.nvm/nvm.sh && nvm install --lts

# Anaconda Setup
# RUN /bin/echo -e 'export LD_LIBRARY_PATH="/usr/lib64:$HOME/anaconda3/lib:$LD_LIBRARY_PATH"' >> $HOME/.bashrc
# RUN /bin/echo -e 'export LD_PRELOAD="/usr/lib64/libstdc++.so.6:$HOME/anaconda3/lib/libmkl_core.so:$HOME/anaconda3/lib/libmkl_sequential.so"' >> $HOME/.bashrc
RUN curl -j -k -L https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh > /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN printf "\nq\nyes\n\n\n" | bash /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh
RUN $HOME/anaconda3/bin/conda update anaconda
RUN $HOME/anaconda3/bin/conda install gensim
RUN $HOME/anaconda3/bin/pip install ipdb
RUN $HOME/anaconda3/bin/pip install -r /var/tmp/scripts/requirements.txt
# RUN bash /var/tmp/scripts/setup_ai.sh
RUN /bin/echo -e "\$include /etc/inputrc\nset bell-style none" > $HOME/.inputrc
RUN /bin/echo -e 'export ANACONDA_HOME=$HOME/anaconda3' >> $HOME/.bashrc
RUN perl -i -pe 's;^export PATH=(.*);export PATH=\$ANACONDA_HOME/bin:$1;' $HOME/.bashrc

# SDKMAN & JVM Setup
RUN /bin/bash -c 'curl -s "https://get.sdkman.io" | /bin/bash && \
source "$HOME/.sdkman/bin/sdkman-init.sh" && \
sdk install java && \
sdk install scala && \
sdk install gradle && \
sdk install sbt'

# PostgreSQL Setup
USER postgres
RUN /etc/init.d/postgresql start && psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD 'postgres'"
USER root
RUN /bin/echo -e 'host	all	all	0.0.0.0/0	md5' >> /etc/postgresql/9.5/main/pg_hba.conf
RUN /bin/echo -e 'host	all	all	::/0	md5' >> /etc/postgresql/9.5/main/pg_hba.conf
RUN perl -i -pe 's;local[\t\s]*all[\t\s]*postgres[\t\s]*peer;local\tall\tpostgres\tmd5;' /etc/postgresql/9.5/main/pg_hba.conf
RUN /bin/echo -e "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf
RUN perl -i -pe 's;(^Require local);#$1\nAllow From all;' /etc/apache2/conf-available/phppgadmin.conf && \
perl -i -pe "s/(\$conf['extra_login_security'].*)true;/\$1false;/" /etc/phppgadmin/config.inc.php
RUN chown -R dev:dev /home/dev

# Apache2 Setup
RUN perl -i -pe 's;^(short_open_tag.*)Off;$1On;' /etc/php/7.0/apache2/php.ini

# Leiningen Setup
USER dev
RUN /bin/bash -c 'curl -o $HOME/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
chmod 755 /home/dev/bin/lein && \
source "$HOME/.sdkman/bin/sdkman-init.sh" && \
/home/dev/bin/lein'

# Cleanup
USER root
RUN perl -0777 -i -pe 's/(export PATH.*?\n)(.*?)(?=\n?#THIS MUST BE.*)/$2$1/s' $HOME/.bashrc

RUN rm /var/tmp/Anaconda3-4.3.1-Linux-x86_64.sh

# Configurations
EXPOSE 80 8000 8080 3306 5432
COPY scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]