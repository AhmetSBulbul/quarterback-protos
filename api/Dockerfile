FROM golang
WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /srv/app.bin
CMD ["/srv/app.bin"]

# FROM scratch
# COPY --from=0 /srv/app.bin /srv/app.bin
