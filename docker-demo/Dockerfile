
# build stage
FROM golang:alpine AS build-env
#FROM scratch

ADD . /src

# Command works:

# VERSION to use with 'FROM alpine' below:
#RUN cd /src && go build -o docker-demo

# VERSION to use with 'FROM scratch' below:
#RUN cd /src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-w' -o docker-demo *.go
RUN cd /src && CGO_ENABLED=0 go build -a -o docker-demo

# final stage
FROM scratch
#FROM alpine

ADD static /app/static
ADD templates /app/templates

WORKDIR /app
COPY    --from=build-env /src/docker-demo /app/

EXPOSE 80
ENTRYPOINT ["/app/docker-demo"]
CMD ["-listen=:80"]

