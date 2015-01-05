LOGIN() {
    [ -z "$MDP" ] && read -s -p "MDP> " MDP
    [ -z "$MDP" ] && die "Please set MDP variable"

    #docker login
    docker login -u mjbright -p $MDP -e docker@mjbright.net
}

TEST4() {
    LOGIN
    #set -x
    #set +x
}

