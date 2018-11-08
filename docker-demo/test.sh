
RUN() {
    CMD="$*"

    echo "-- $CMD"
    $CMD
}


RUN docker run -d -p 8081:80 mjbright/docker-demo:1

RUN sleep 2

#RUN wget -O - http://127.0.0.1:8081
RUN curl http://127.0.0.1:8081


