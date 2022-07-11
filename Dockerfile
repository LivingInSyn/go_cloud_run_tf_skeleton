from golang:1.18

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

# move everything into usr src app
COPY . .
RUN go build -v -o cloud-run-app ./...
RUN ln -sf /usr/src/app/cloud-run-app /usr/local/bin/cloud-run-app

CMD ["cloud-run-app"]