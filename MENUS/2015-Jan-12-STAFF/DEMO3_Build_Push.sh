
# [ ! -z "$DEMO_PROFILE" ] && echo "DEMO_PROFILE:$DEMO_PROFILE"
# [ -f "$DEMO_PROFILE" ] && echo "-f DEMO_PROFILE:$DEMO_PROFILE"
# env | grep DEMO_PROFILE

SCRIPT=$0
SCRIPTDIR=${0%/*}
PROFILE=$SCRIPTDIR/profile

[ -f $PROFILE ] && {
    . $PROFILE;
}

#[ ! -z "$DEMO_PROFILE" ] && [ -f "$DEMO_PROFILE" ] && . $DEMO_PROFILE

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



