
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

echo; pause "Let's launch an image of a different Linux version"
echo "Our host is running (o/p of <uname -a>): "
uname -a
cat /etc/lsb-release

echo; pause "Now let's launch a CentOS image (open source version of RedHat Linux)"

echo "Our contained is running (o/p of <uname -a> and <cat /etc/centos-release>): "
CMD="uname -a; cat /etc/centos-release"
SHOW_DOCKER run centos /bin/sh -c "\"$CMD\""

SHOW_DOCKER run -it centos bash


