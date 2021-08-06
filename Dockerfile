FROM golang:alpine
RUN go version
WORKDIR /go/src/app
ADD . .
RUN go mod init
RUN go get -d github.com/gorilla/mux
RUN go get -d github.com/prometheus/client_golang/prometheus
RUN go get -d github.com/prometheus/client_golang/prometheus/promhttp
RUN export CGO_ENABLED=0 && go build -a -installsuffix cgo --ldflags "-s -w" -o server

FROM alpine

COPY --from=0 /go/src/app/server /root

EXPOSE 8080
WORKDIR /root/

CMD ["./server"]
