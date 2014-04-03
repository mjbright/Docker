FROM ubuntu:saucy
MAINTAINER Michael Bright <dockerfiles@mjbright.net>

#RUN echo "deb http://archive.ubuntu.com/ubuntu/ saucy main universe" >> /etc/apt/sources.list
RUN apt-get update

RUN echo 'alias ll="ls -al"' >> ~/.bashrc
RUN echo 'set -o vi' >> ~/.bashrc
CMD bash

# Install packages
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tar build-essential curl git-core

# Add Python stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python python-dev python-distribute python-pip

# Add Node.js for Ruby web server:
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs

# Add Ruby Version Manager: RVM
#RUN curl -L https://get.rvm.io | bash -s stable --ruby
RUN curl -L https://get.rvm.io > install_rvm.sh
RUN chmod +x install_rvm.sh
#RUN bash -x -s stable --ruby; echo $?
#RUN curl -L https://get.rvm.io | bash -x -s stable --ruby; echo $?
#RUN echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc

## LONG: rails installation
RUN bash -c /install_rvm.sh stable --ruby

RUN echo '[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/rvm/bin:$PATH' >> ~/.bashrc
RUN cat ~/.bashrc
RUN . ~/.bashrc; echo $?

## ENV PATH /usr/local/rvm/bin:$PATH

RUN echo $PATH
RUN echo "ENV=";env
RUN . ~/.bashrc; rvm list known
RUN . ~/.bashrc; rvm get stable
RUN . ~/.bashrc; rvm install ruby-2.1.0
RUN . ~/.bashrc; rvm use ruby-2.1.0
# BETTER:
#RUN rvm install ruby-2.1.1
#RUN rvm use ruby-2.1.1

#RUN adduser --group rvm rails
RUN adduser --disabled-password --gecos "Rails User" rails
RUN adduser rails rvm

RUN echo 'alias ll="ls -al"' >> ~rails/.bashrc
RUN echo 'set -o vi' >> ~rails/.bashrc
RUN echo '[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"' >> ~rails/.bashrc
RUN echo 'export PATH=/usr/local/rvm/bin:$PATH' >> ~rails/.bashrc
RUN echo 'export PATH=/usr/local/rvm/rubies/ruby-2.1.0/bin:$PATH' >> ~rails/.bashrc
RUN echo 'source /etc/profile.d/rvm.sh' >> ~rails/.bashrc
ENV PATH /usr/local/rvm/rubies/ruby-2.1.0/bin:$PATH

RUN echo PATH="$PATH"
RUN . ~rails/.bashrc; echo $?
RUN echo PATH="$PATH"

#RUN . ~/.bashrc; echo $?; gem install rails
RUN . ~/.bashrc; echo $?; /usr/local/rvm/rubies/ruby-2.1.0/bin/gem install rails

##############################################################################
# USER:
USER rails
#ENV PATH /usr/local/rvm/bin:$PATH


# VOLUME ["/tmp"]

# RUN ENV A=1
# RUN [ $A -eq 1 ] && exit 1

RUN .~/.bashrc; rvm all do ruby --version

#ENV PATH /usr/local/rvm/rubies/ruby-2.1.0/bin:$PATH
RUN . ~/.bashrc; echo $?; gem install rails
RUN . ~/.bashrc; rails -v
RUN rails -v

#RUN mkdir -p /py_wsgi
#ADD app.py /py_wsgi/app.py
#RUN chmod 755 /py_wsgi/*.py
#EXPOSE 80
#WORKDIR  /py_wsgi

#CMD python server.py

