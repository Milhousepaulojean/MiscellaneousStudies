# stage de build
#FROM golang:latest AS build

# stage de build
FROM golang:alpine AS stage1

WORKDIR /app

COPY . /app

#RUN apk add --no-cache go
RUN go build -o api main.go


FROM scratch AS stage2
WORKDIR /app
COPY --from=stage1 /app .

# stage imagem final
EXPOSE 8000
CMD [ "./api" ]


