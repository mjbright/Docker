DEMO9() {
    BANNER "Demo creation of a Python twistd image, then run as a container"

    _TMP=/tmp/py_twistd.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > Dockerfile << "EOF"
FROM base

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install telnet python python-twisted-web

CMD twistd web --path=./ --port=9000

EXPOSE 9000

EOF

    SHOW_DOCKER build -t mjbright/twistd .

    SHOW_DOCKER run -p 9000:9000 -i -t mjbright/twistd
}

