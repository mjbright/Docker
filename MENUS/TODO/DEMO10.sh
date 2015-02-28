DEMO10() {
    BANNER "Inspecting images"

    CNT=mysql

    echo; pause "Let's look at the history of mjbright/$CNT"
    SHOW_DOCKER history mjbright/$CNT

    echo; pause "Inspecting processes $CNT"
    SHOW_DOCKER top $CNT

    echo; pause "Inspecting $CNT"
    SHOW_DOCKER inspect $CNT

    echo; pause "Inspecting $CNT => get ip address"
    set -x
    docker inspect $CNT | grep IPAddress | cut -d '"' -f 4
    docker inspect $CNT | jq -r '.[0].NetworkSettings.IPAddress'
    set +x

    echo; pause "Look at all images hierarchy"
    set -x
    docker images -v | dot -Tpng -o docker.png
    set +x

    #echo "Now look at http://localhost:8080"
    #python -m SimpleHTTPServer 8080

}
