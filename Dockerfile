FROM quay.io/projectquay/golang:1.20 AS builder
WORKDIR /src
COPY src .
ARG TARGETOS=linux TARGETARCH=amd64 ARG APP_PFX=
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o app

FROM scratch
ADD ./html /html
COPY --from=builder /src/app .
ENTRYPOINT [ "/app" ]
EXPOSE 8035
