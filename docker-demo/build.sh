
RUN() {
    CMD="$*"

    echo "-- $CMD"
    $CMD
}

RUN docker build -t mjbright/docker-demo:1 .


