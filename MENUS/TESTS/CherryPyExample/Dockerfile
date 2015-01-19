
# Inspired by:
#    http://www.defuze.org/archives/315-create-a-docker-container-for-your-cherrypy-application.html

FROM ubuntu:14.10

RUN useradd -m -d /home/web web && mkdir /home/web/.venv &&\

apt-get update && sudo apt-get upgrade -y && \
apt-get install -y libc6 libc6-dev libpython2.7-dev libpq-dev libexpat1-dev libffi-dev libssl-dev python2.7-dev python-pip && \
pip install virtualenv && \
virtualenv -p python2.7 /home/web/.venv/default && \
/home/web/.venv/default/bin/pip install cython && \
/home/web/.venv/default/bin/pip install cherrypy==3.6.0 pyopenssl mako psycopg2 python-memcached sqlalchemy && \
apt-get autoclean -y && \
apt-get autoremove -y && \
chown -R web.web /home/web/.venv

USER web
WORKDIR /home/web
ENV PYTHONPATH /home/web/webapp

COPY webapp /home/web/webapp

ENTRYPOINT ["/home/web/.venv/default/bin/cherryd", "-i", "server"]



