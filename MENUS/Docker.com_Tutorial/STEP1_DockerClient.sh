
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

################################################################################

[ -z "$DOCKERHUB_USER" ] &&
    die "You must export DOCKERHUB_USER variable to your Docker hub username"

USER=$DOCKERHUB_USER # Username on docker hub

################################################################################

echo; pause "Let's look at the Docker client commands"
echo docker
docker 2>&1 | less

echo; pause "Let's see what version we're running"
SHOW_DOCKER version

echo; pause "Now let's search for the tutorial image [on Docker Hub]"
SHOW_DOCKER search tutorial

echo; pause "Now let's pull down the learn/tutorial image"
SHOW_DOCKER pull learn/tutorial

echo; pause "Now let's run the image, and get it to print 'hello world'"
SHOW_DOCKER run learn/tutorial echo "Hello World"

echo; pause "Now let's install the ping utility on top of our image"
SHOW_DOCKER run learn/tutorial apt-get install -y ping

echo;
echo "But we need to save our changes."
echo "So first we get the container details using 'docker ps -l'"
SHOW_DOCKER ps -l
ID=$(docker ps -lq)

echo
echo "So our container id is $ID"
echo; pause "Now let's look at options to the docker commit command"
SHOW_DOCKER commit

echo; pause "Now let's commit our image locally as $USER/ping"
SHOW_DOCKER commit --author="Tutorial\ Author" -m="Commit\ Message" $ID $USER/ping

echo; pause "Let's check for the image <docker images | grep $USER/ping>"
#SHOW_DOCKER images | grep $USER/ping
docker images | grep $USER/ping
IMAGE_ID=$(docker images | grep $USER/ping | awk '{print $3;}')

PING_TARGET=www.google.com
PING_TARGET=10.3.3.117
echo; pause "Let's now use our image to ping $PING_TARGET"
SHOW_DOCKER run $USER/ping ping -c 4 $PING_TARGET

echo; pause "Let's now let's examine our container"
SHOW_DOCKER ps -l
ID=$(docker ps -ql)

echo; pause "Let's now inspect our container using <docker inspect $ID>"

SHOW_DOCKER inspect $ID | less

echo; pause "Let's now push our $USER/ping image to our docker hub account"
SHOW_DOCKER push $USER/ping




