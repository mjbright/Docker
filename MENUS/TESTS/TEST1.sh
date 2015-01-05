
TEST1() {
     DEBUG=1
     DEBUG_BANNER "Show basic container launching in interactive mode"

     #echo; pause "Starting long-lived Docker container in interactive mode:"
     #CMD="while true;do echo 'hello world'; date; sleep 1;done"
     #CMD="while true;do echo \\\`date\\\` 'hello world'; sleep 1;done"
     CMD="while true;do echo \\\$(date) 'hello world'; sleep 1;done"
     #echo E
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     #SHOW_DOCKER run -i -t base /bin/sh -c "$CMD"
     #SHOW_DOCKER run -i -t base /bin/sh -c $CMD
     #SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
}

