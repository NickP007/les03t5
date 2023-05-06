FROM quay.io/projectquay/golang:1.20 AS builder
WORKDIR /src
COPY src .
ARG TARGETOS=linux TARGETARCH=amd64 ARG APP_PFX=
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o app${APP_PFX}

FROM scratch
ADD ./html /html
ARG APP_PFX=
COPY --from=builder /src/app${APP_PFX} .
ENTRYPOINT [ "/app${APP_PFX}" ]
EXPOSE 8035
