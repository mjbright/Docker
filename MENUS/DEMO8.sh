
DEMO8() {
    BANNER "Demo creation of a Python WSGI image, then run as a container"

    _TMP=/tmp/py_wsgi.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > requirements.txt << "EOF"
flask
cherrypy
EOF

    cat > app.py << "EOF"
from flask import Flask

app = Flask(__name__)

@app.route("/")

def hello():
    return "Hello World!"

if (__name__) == "__main__":
    app.run()
EOF

    cat > server.py << "EOF"
# Import your application as:
# from app import application
# Example:

from app import app

# Import CherryPy
import cherrypy

if __name__ == '__main__':

    # Mount the application
    cherrypy.tree.graft(app, "/")

    # Unsubscribe the default server
    cherrypy.server.unsubscribe()

    # Instantiate a new server object
    server = cherrypy._cpserver.Server()

    # Configure the server object
    server.socket_host = "0.0.0.0"
    server.socket_port = 80
    server.thread_pool = 30

    # For SSL Support
    # server.ssl_module            = 'pyopenssl'
    # server.ssl_certificate       = 'ssl/certificate.crt'
    # server.ssl_private_key       = 'ssl/private.key'
    # server.ssl_certificate_chain = 'ssl/bundle.crt'

    # Subscribe this server
    server.subscribe()

    # Start the server engine (Option 1 *and* 2)

    cherrypy.engine.start()
    cherrypy.engine.block()
EOF

    cat > Dockerfile << "EOF"
FROM ubuntu:saucy
MAINTAINER Michael Bright <dockerfun@mjbright.net>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt-get update

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tar git curl vim wget dialog net-tools build-essential

# Add Python stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python python-dev python-distribute python-pip

RUN pip install flask
RUN pip install cherrypy

RUN mkdir -p /py_wsgi
RUN cd /py_wsgi

ADD app.py /py_wsgi/app.py
ADD server.py /py_wsgi/server.py
ADD requirements.txt /py_wsgi/requirements.txt
RUN chmod 755 /py_wsgi/*.py

RUN pip install -r /py_wsgi/requirements.txt

EXPOSE 80

WORKDIR  /py_wsgi

CMD python server.py

EOF

    echo; pause "About to build py_wsgi image"
    SHOW_DOCKER build -t $_USER/py_wsgi .

    echo; pause "About to run py_wsgi image"
    SHOW_DOCKER run -p 80:80 -i -t $_USER/py_wsgi
}

