
DEMO6() {

    RMALL
    #DEBUG_BANNER "Show pushing to repository"
    BANNER "Show pushing to repository"

    docker LOGIN

    echo; pause "Let's search the registry for mjbright"
    SHOW_DOCKER search mjbright

    echo; pause "About to startup our local ping image"
    SHOW_DOCKER run --name PING -d my/ping www.google.com

    echo; pause "About to attach to the new container"
    SHOW_DOCKER attach PING

    echo; pause "About to commit the container to an image called mjbright/ping"
    SHOW_DOCKER commit PING mjbright/ping
    SHOW_DOCKER images

    echo; pause "About to push the image mjbright/ping to the registry"
    SHOW_DOCKER push mjbright/ping

    echo; pause "Let's look at the history (see those ids)"
    SHOW_DOCKER history mjbright/ping

    echo; pause "Let's search the registry for mjbright"
    SHOW_DOCKER search mjbright
}

