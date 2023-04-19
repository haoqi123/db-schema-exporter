FROM golang:1.20.3
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o db-schema-exporter
CMD ["./db-schema-exporter"]