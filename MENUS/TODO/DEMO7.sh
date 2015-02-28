
DEMO7() {
    BANNER "Demo creation of a mysql image, then run as a container"

    _TMP=/tmp/mysql.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > run.sh <<"EOF"
#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
        /create_mysql_admin_user.sh
fi
exec supervisord -n
EOF

    cat > start.sh <<"EOF"
#!/bin/bash
exec mysqld_safe

EOF

   cat > supervisord-mysqld.conf <<"EOF"
[program:mysqld]
command=/start.sh
numprocs=1
autostart=true
EOF

    cat > Dockerfile <<"EOF"
FROM ubuntu:saucy
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]
EOF

    cat > my.cnf <<"EOF"
[mysqld]
bind-address=0.0.0.0
EOF

cat > create_db.sh <<"EOF"
#!/bin/bash

if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <db_name>"
        exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Creating database $1"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5
        mysql -uroot -e "CREATE DATABASE $1"
        RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
EOF

cat > create_mysql_admin_user.sh <<"EOF"
#!/bin/bash

if [ -f /.mysql_admin_created ]; then
        echo "MySQL 'admin' user already created!"
        exit 0
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5
        mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
        RET=$?
done

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.mysql_admin_created

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"
EOF

cat > import_sql.sh <<"EOF"
#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <password> </path/to/sql_file.sql>"
        exit 1
fi

echo "=> Starting MySQL Server"
/usr/bin/mysqld_safe > /dev/null 2>&1 &
sleep 5
echo "   Started with PID $!"

echo "=> Importing SQL file"
mysql -uroot -p"$1" < "$2"

echo "=> Stopping MySQL Server"
mysqladmin -uroot -p"$1" shutdown

echo "=> Done!"
EOF

    echo; pause "About to build mysql image"
    SHOW_DOCKER build -t $_USER/mysql .
    
    echo; pause "About to run container (as daemon) from mysql image"
    #SHOW_DOCKER run -d --name mysql $_USER/mysql
    SHOW_DOCKER run -d --name mysql $_USER/mysql

    # Pickup id of our mysql container:
    MYSQL_ID=$(docker ps -q -l)

    echo; pause "About to run linked container to show DB env"
    SHOW_DOCKER run --link mysql:db ubuntu env

    echo; pause "Getting password from container logs [daemon stdout]";
    MDP=`docker logs ${MYSQL_ID} 2>/dev/null | perl -ne 'if (/mysql -uadmin -p(\S+)/) { print $1; }'`
    echo "admin password is $MDP"

    echo; pause "Getting host/port info from container environment"
    HOST_PORT=$(docker run --link mysql:db ubuntu bash -c 'echo ${DB_PORT#tcp://}')
    HOST=${HOST_PORT%:*}
    PORT=${HOST_PORT#*:}
    echo "HOST=$HOST PORT=$PORT"
    echo; pause "echo 'show databases;' | mysql -uadmin -p$MDP -h$HOST -P$PORT"
    echo
    echo "show databases;" | mysql -uadmin -p$MDP -h$HOST -P$PORT
}

