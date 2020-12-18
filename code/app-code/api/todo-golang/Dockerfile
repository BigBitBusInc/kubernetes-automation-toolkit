FROM golang:latest

RUN mkdir /app
WORKDIR /app

RUN go get go.mongodb.org/mongo-driver/mongo
RUN go get -u github.com/gorilla/mux
COPY . .
RUN go build -o main

EXPOSE 8080

CMD ["./main"]
