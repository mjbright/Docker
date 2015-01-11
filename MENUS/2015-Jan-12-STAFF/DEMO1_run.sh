
# [ ! -z "$DEMO_PROFILE" ] && echo "DEMO_PROFILE:$DEMO_PROFILE"
# [ -f "$DEMO_PROFILE" ] && echo "-f DEMO_PROFILE:$DEMO_PROFILE"
# env | grep DEMO_PROFILE

SCRIPT=$0
SCRIPTDIR=${0%/*}
PROFILE=$SCRIPTDIR/profile

[ -f $PROFILE ] && {
    . $PROFILE;
}



[ ! -z "$DEMO_PROFILE" ] && [ -f "$DEMO_PROFILE" ] && . $DEMO_PROFILE

RMALL
#LIST_ALL pause

echo; pause "Let's look at current Docker containers"
LIST_ALL

BANNER "Show basic container launching"

echo; pause "List all local Docker images"
SHOW_DOCKER images

# IMAGE1=`docker images | head -2 | tail -1 | awk '{print $1;}'`
# echo; pause "Show history of first local Docker image [$IMAGE1]"
# SHOW_DOCKER history $IMAGE1

echo; pause "Starting Docker container in interactive mode: 'hello world'"
SHOW_DOCKER run base echo 'hello world'
#SHOW_DOCKER run --name HelloWorld_`dtime` base echo 'hello world'

echo; pause "Let's look at current Docker containers"
LIST_ALL

RMALL

echo; pause "Starting long-lived Docker container in interactive mode:"
#CMD="while true;do echo 'hello world'; date; sleep 1;done"
#CMD="while true;do echo \`date\` 'hello world'; sleep 1;done"
CMD="while true;do echo \\\$(date) 'hello world'; sleep 5;done"
SHOW_DOCKER run base /bin/sh -c "\"$CMD\""


