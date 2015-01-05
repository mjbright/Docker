DEMO2() {
     RMALL
     BANNER "Show daemon container launching"

     NAME=DAEMON`dtime`

     echo; pause "About to start container as daemon"
     #CMD="while true;do let LOOP=LOOP+1; echo \\\$LOOP:'STDERR' >&2; echo \\\$(date) 'hello world'; sleep 1;done"
     CMD="while true;do let LOOP=LOOP+1; echo \\\$LOOP: \\\$(date) 'hello world'; sleep 5;done"
     #SHOW_DOCKER run --name=$NAME -a stdout -a stderr -d -t base /bin/bash -c "\"$CMD\""
     SHOW_DOCKER run --name=$NAME -d -t base /bin/bash -c "\"$CMD\""

     echo; pause "Let's look at process threads on host system"
     echo; echo "Host process threads (ps output):"
     SHOW_THREADS
     echo; echo "Docker containers:"
     LIST_ALL

     echo; pause "Let's look at what's happening on the host filesystem"
     echo "sudo ls -altr /var/lib/docker/containers:"
     sudo ls -altr /var/lib/docker/containers

     CONTAINER_ID=`sudo ls -tr /var/lib/docker/containers | tail -1`
     echo; echo CONTAINERID=$CONTAINER_ID

     LOG=/var/lib/docker/containers/$CONTAINER_ID/${CONTAINER_ID}-json.log
     echo
     sudo ls -altr $LOG
     #sudo tail -1 $LOG
     ## echo; pause "Now let's tail that log file [last 2 lines]"
     ## sudo tail -2 $LOG

     echo; pause "Now let's tail that log file"
     sudo tail -f $LOG

     #echo; echo "sleep 2"
     #sleep 2
     #echo
     #sudo ls -altr $LOG
     #sudo tail -1 $LOG

     pause "Daemon is running, now let's attach to it's stdout"
     SHOW_DOCKER attach $NAME
}
