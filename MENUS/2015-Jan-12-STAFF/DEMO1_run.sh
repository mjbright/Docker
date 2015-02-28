
SCRIPT=$0
SCRIPTDIR=${0%/*}

sourceProfiles() {
    DIR=$SCRIPTDIR

    # Search for profile files from top dir (containing MENUS dir) to this dir
    # and source them top down (so this dir is most specific):

    LOOP=0
    while [ ! -d ${DIR}/MENUS ];do
        [ -f $DIR/profile ] && PROFILES="$DIR/profile $PROFILES"
        DIR=$DIR/..
        #echo "PROFILES=$PROFILES"
        #echo "read _dummy"
        #read _dummy
        let LOOP=LOOP+1
        [ $LOOP -gt 10 ] && { echo "Error: looping in sourceProfiles()" >&2; exit 2; }
    done

    for PROFILE in $PROFILES;do
        echo "Sourcing $PROFILE"
        source $PROFILE
    done
}
sourceProfiles

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


