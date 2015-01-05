TEST3() {
    RMALL
    docker images | grep my/ping && {
        echo "Removing exisint 'my/ping' image";
        SHOW_DOCKER rmi my/ping;
    }


    echo "IMAGES:"
    docker images

    DOCKERFILE_EXAMPLE

    echo; pause "Now let's rerun that build"
    DOCKERFILE_EXAMPLE

    echo; pause "Now let's rerun that ping"
    SHOW_DOCKER run my/ping www.google.com
}

