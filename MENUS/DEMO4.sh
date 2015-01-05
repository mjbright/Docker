DEMO4() {
    SETUP_WORDPRESS
}

SETUP_WORDPRESS() {
    BANNER "Demonstrate building from a dockerfile"

    DOCKERFILE=/tmp/wordpress.dockerfile
    YES=""
    YES="-y"
    cat > $DOCKERFILE <<"EOF"
FROM ubuntu
#FROM base
RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 apache2-mpm-prefork apache2-utils apache2.2-common libapache2-mod-php5 libapr1 libaprutil1 libdbd-mysql-perl libdbi-perl libnet-daemon-perl libplrpc-perl libpq5 mysql-common php5-common php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim wget net-tools
RUN wget http://wordpress.org/latest.tar.gz && mv latest.tar.gz /var/www
RUN /etc/init.d/apache2 start
EXPOSE 80
EOF

    echo
    echo
    echo "DOCKERFILE CONTENTS:"
    more $DOCKERFILE
    echo; pause "About to launch build:"

    echo "docker build -t wpress - < $DOCKERFILE"
    docker build -t wpress - < $DOCKERFILE

    #echo "docker run wpress -d -p 80:80"
    #echo "docker run -d -p 80:80 wpress /bin/bash"
    #docker run -d -p 80:80 wpress /bin/bash
    echo "docker run -i -t -p 80:80 wpress /bin/bash"
    docker run -i -t -p 80:80 wpress /bin/bash
    #"/etc/init.d/apache2 start" | sudo lxc-attach --name $FULLID
    ID=wpress
    FULLID=`GETFULLID $ID`
    #echo "/etc/init.d/apache2 start" | sudo lxc-attach --name $FULLID
    echo "/etc/init.d/apache2 start" | docker-attach --name $FULLID
    echo "PERFORM /etc/init.d/apache2 start"
    ATTACH $ID

    wget localhost:80
}

