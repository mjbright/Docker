#!/bin/bash

VERSIONS=6

#EXPOSE_PORT=4321
EXPOSE_PORT=80

################################################################################
# Functions:

die() {
    echo "$0: die - $*" >&2
    exit 1
}

push_images() {
    for image in $*; do
        echo; echo "push $image"
        docker push $image
    done
}

build_image() {
    TXT_IMAGE=$1; shift
    PNG_IMAGE=$1; shift
    IMAGE_NAME_VERSION=$1; shift

    IMAGE_VERSION=${IMAGE_NAME_VERSION#*:}

    sed "s/REPLACE_LOGO/$PNG_IMAGE/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl

    set -x
    docker build -t $IMAGE_NAME_VERSION .
    set +x
}

################################################################################
# Main:

#DHUB_ARGS=""
#[ ! -z "$DHUB_USER" ] && DHUB_ARGS="$DHUB_ARGS -u $DHUB_USER"
echo; echo "Docker login:"
#docker login $DHUB_ARGS
if [ ! -z "$DHUB_PWD" ];then
    [ -z "$DHUB_USER" ] && die "Must set DHUB_USER if DHUB_PWD is used"

    echo "$DHUB_PWD" | docker login --username $DHUB_USER --password-stdin
else
    docker login
fi


build_image "docker_blue.txt"   "docker_blue.png"   mjbright/docker-demo:1
build_image "docker_green.txt"  "docker_green.png"  mjbright/docker-demo:2
build_image "docker_red.txt"    "docker_red.png"    mjbright/docker-demo:3
build_image "docker_yellow.txt" "docker_yellow.png" mjbright/docker-demo:4
build_image "docker_cyan.txt"   "docker_cyan.png"   mjbright/docker-demo:5
build_image "docker_white.txt"  "docker_white.png"  mjbright/docker-demo:6

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   mjbright/k8s-demo:1
build_image "kubernetes_green.txt"  "kubernetes_green.png"  mjbright/k8s-demo:2
build_image "kubernetes_red.txt"    "kubernetes_red.png"    mjbright/k8s-demo:3
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" mjbright/k8s-demo:4
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   mjbright/k8s-demo:5
build_image "kubernetes_white.txt"  "kubernetes_white.png"  mjbright/k8s-demo:6

IMAGES=""
for image in mjbright/docker-demo mjbright/k8s-demo; do
   for version in $(seq $VERSIONS); do
       IMAGES+="${image}:${version} "
   done
done

push_images $IMAGES

exit 0


