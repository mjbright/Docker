
#######################################################
# Script presents a menu starting from the specified
# directory (or MENUS in the current directory), allowing
# to navigate into/out of directories, invoke demo
# scripts

# Default root dir:
ROOT=./MENUS

#######################################################
# function: debug
# Show debug output if _DEBUG is set to non-zero value:
_DEBUG=0
function debug {
    [ $_DEBUG -eq 0 ] && return
    echo $*
}

#######################################################
# function: enumDir
#    - Populate array variables SCRIPTS/DIRS with scripts/dirs seen in current dir
function enumDir {
    SCRIPTS=()
    DIRS=()
    for item in *;do
        debug "item=$item \$0=$0"
        [ $item = ${0##*/} ] && break;
        [ -f $item ] && [ -x $item ] && { SCRIPTS+=("$item"); debug "Added script"; }
        [ -d $item ]                 && { DIRS+=("$item"); debug "Added dir"; }
    done

    scripts=${#SCRIPTS[@]}
    dirs=${#DIRS[@]}
    let entries=scripts+dirs
    debug "Found $scripts executable scripts <${SCRIPTS[@]}>"
    debug "Found $dirs               dirs <${DIRS[@]}>"
}

#######################################################
# function: showMenuDir
#    - Present menu of scripts/dirs
#    - Invoke scripts, go up/down into dirs based on selection
function showMenuDir {
    if [ $# -eq 2 ];then
        DIR=$1;  shift;
        ROOT=$1; shift;
    else
        DIR=$1;  shift;
        ROOT=$DIR
    fi

    cd  $DIR
    ## [ -f profile ] && { 
    ##     debug "export DEMO_PROFILE=profile"
    ##     export DEMO_PROFILE=profile
    ##     #debug ". profile";
    ##     #. profile;
    ## }

    debug "cd [$PWD]"

    enumDir

    echo
    echo "Select script to run (or directory):"
    ITEMS=("${SCRIPTS[@]}" "${DIRS[@]}" "-- UP/EXIT --")
    select opt in "${ITEMS[@]}"
    do
        debug "OPT=$opt REPLY=$REPLY SCRIPTS=<${SCRIPTS[@]}>"
        [ "$REPLY" = "q" ] && exit 0

        echo $REPLY | grep -E "^[0-9][0-9]*$" || {
            echo "Entered non-numeric value<$_INPUT>";
            continue;
        }

        if [ $REPLY -gt $entries ];then
            debug "OORANGE"
            [ $DIR == $ROOT ] && {
                debug "------------------ exiting -----------------------------";
                exit 0;
            } || {
                debug "------------------ leaving ... cd .. -------------------";
                cd ..;
                debug "[$PWD] ... after leaving":
                break;
            }
        elif [ $REPLY -le $scripts ];then
            debug "IN SCRIPTS RANGE"
            SCRIPT=./$opt
            debug "A script ($SCRIPT)"
            $SCRIPT
        else
            debug "IN DIRS RANGE"
            debug "A dir [$DIR/$opt]"
            DIR=$opt
            showMenuDir $DIR $ROOT
            debug "[$PWD] ... after showMenuDir":
            enumDir
        fi
    done
}

#######################################################
# Process command-line args:

# Usage:
#   Script [<rootdir>]

while [ ! -z "$1" ];do
    case $1 in
        *)
           ROOT=$1;;
    esac
    shift
done

# Invoke menu:
debug "[$PWD] showMenuDir $ROOT"
showMenuDir $ROOT

