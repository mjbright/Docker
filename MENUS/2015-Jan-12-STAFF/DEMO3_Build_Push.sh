
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

echo; pause "Let's create a new image and then upload it to the Docker hub"

echo; pause "First what 'mjbright' images exist on the Docker hub?"
SHOW_DOCKER search mjbright

echo; pause "Contents of our Dockerfile we will build from:"
cat Dockerfile

echo; pause "Now let's build the image (with a 'unique' name)"
SHOW_DOCKER build -t mjbright/test_$$ .

NAME=$(docker images | head -2 | tail -1 | awk '{print $1;}')
echo "New image name is <$NAME>"

echo; pause "Now let's launch our image as a new container"
echo; echo "Now connect to web server from the host using command: 'wget -O - localhost:8000'"
echo

SHOW_DOCKER run -it -p 8000:8000 $NAME

echo; pause "Now let's push our image to the public Docker repository"
#SHOW_DOCKER push mjbright/$NAME
SHOW_DOCKER push $NAME

SHOW_DOCKER search mjbright



