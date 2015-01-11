FROM ubuntu:latest
MAINTAINER <dockerbuilds@mjbright.net>

RUN apt-get install python3
ADD index.html index.html
ADD favicon.ico favicon.ico

CMD [ "python3", "-m", "http.server" ]

