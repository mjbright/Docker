
_DEBUG=0
function debug {
    [ $_DEBUG -eq 0 ] && return
    echo $*
}

function myselect {
    debug "::myselect[args=$#] <$*>"
    local OPT

    OPTIONS=()
    #for OPT in "$@";do; #debug OPT=$OPT; #done
    #debug ${#OPTIONS[@]}
        #debug "OPTIONS[]+=$OPT"
        #debug ${#OPTIONS[@]}
    #debug OPTIONS=${OPTIONS[@]}
    for OPT in "$@";do
        OPTIONS+=("$OPT")
    done

    while true; do
        local i

        ENTRIES=${#OPTIONS[@]}
        #debug "ENTRIES=$ENTRIES"
        #debug "seq 1 $ENTRIES=<" $(seq 1 $ENTRIES) ">"

        for I in $(seq 1 $ENTRIES);do
             let i=I-1
             echo ${I}-${OPTIONS[$i]}
        done
        read _INPUT
         
        echo $_INPUT | grep -E "^[0-9][0-9]*$" || {
            echo "Entered non-numeric value<$_INPUT>";
            continue;
        }

        if [ $_INPUT -lt 1 ];then
            echo "$_INPUT is out of range (below 0)"
        elif [ $_INPUT -gt $ENTRIES ];then
            echo "$_INPUT is out of range (above $ENTRIES)"
        else
            let I=_INPUT
            let i=I-1
            OPT=${OPTIONS[$i]}
            echo "Entered <$_INPUT> $OPT"
            break
        fi

    done

    opt=$OPT
    REPLY=$I

    debug "myselect: OPT=$opt REPLY=$REPLY"
}

function enumDir {
    SCRIPTS=()
    DIRS=()
    for item in *;do
        debug "item=$item \$0=$0"
        [ $item = ${0##*/} ] && break;
        [ -f $item ] && [ -e $item ] && { SCRIPTS+=("$item"); debug "Added script"; }
        [ -d $item ]                 && { DIRS+=("$item"); debug "Added dir"; }
    done

    scripts=${#SCRIPTS[@]}
    dirs=${#DIRS[@]}
    let entries=scripts+dirs
    echo "Found $scripts executable scripts <${SCRIPTS[@]}>"
    echo "Found $dirs               dirs <${DIRS[@]}>"
}

function showMenuDir {
    if [ $# -eq 2 ];then
        DIR=$1;  shift;
        ROOT=$1; shift;
        #cd  $DIR
    else
        DIR=$1;  shift;
        ROOT=$DIR
        #cd  $ROOT
    fi

    cd  $DIR
    debug "cd [$PWD]"

    enumDir

    #[ $DIR != $ROOT ] && DIRS+=".."

    echo
    echo "Select script to run (or directory):"
    #select opt in "${SCRIPTS[@]}" "${DIRS[@]}" "** UP/EXIT **"
    #do
    while true; do
        ITEMS=("${SCRIPTS[@]}" "${DIRS[@]}" "-- UP/EXIT --")
        #ITEMS=("${SCRIPTS[@]}" "${DIRS[@]}" "** UP/EXIT **")
        debug "::::myselect" "${ITEMS[@]}"
        myselect "${ITEMS[@]}"
        #myselect "${SCRIPTS[@]}" "${DIRS[@]}" "** UP/EXIT **"
        debug "OPT=$opt REPLY=$REPLY SCRIPTS=<${SCRIPTS[@]}>"
        if [ $REPLY -gt $entries ];then
            debug "OORANGE"
            [ $DIR == $ROOT ] && {
                echo "------------------ exiting -----------------------------";
                exit 0;
            } || {
                echo "------------------ leaving ... cd .. -------------------";
                cd ..;
                echo "[$PWD] ... after leaving":
                break;
                #return;
            }
        elif [ $REPLY -le $scripts ];then
            debug "IN SCRIPTS RANGE"
            SCRIPT=./$opt
            debug "A script ($SCRIPT)"
            $SCRIPT
            #$DIR/$opt
                #break;
        else
            debug "IN DIRS RANGE"
            debug "A dir [$DIR/$opt]"
            DIR=$opt
            showMenuDir $DIR $ROOT
                #cd ..;
                echo "[$PWD] ... after showMenuDir":
                #break;
                enumDir
        fi
    done

    #echo "------------------ exiting ... cd $ROOT -------------------"
    #cd $ROOT
}

ROOT=.

while [ ! -z "$1" ];do
    case $1 in
        *)
           ROOT=$1;;
    esac
    shift
done


debug "[$PWD] showMenuDir $ROOT"
showMenuDir $ROOT

