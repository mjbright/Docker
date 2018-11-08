
# --no-cache is necessary for build to rebuild artifacts correctly:
CACHE="--no-cache"

RUN() {
    CMD="$*"

    echo "-- $CMD"
    $CMD
}

RUN docker build $CACHE -t mjbright/docker-demo:1 .


