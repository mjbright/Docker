
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


