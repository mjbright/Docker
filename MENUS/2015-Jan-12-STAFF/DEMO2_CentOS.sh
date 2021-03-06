
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

echo; pause "Let's launch an image of a different Linux version"
echo "Our host is running (o/p of <uname -a>): "
uname -a
cat /etc/lsb-release

echo; pause "Now let's launch a CentOS image (open source version of RedHat Linux)"

echo "Our contained is running (o/p of <uname -a> and <cat /etc/centos-release>): "
CMD="uname -a; cat /etc/centos-release"
SHOW_DOCKER run centos /bin/sh -c "\"$CMD\""

SHOW_DOCKER run -it centos bash


