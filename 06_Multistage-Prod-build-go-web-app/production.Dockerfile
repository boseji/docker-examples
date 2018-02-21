# Minimum System For the Production Image
FROM alpine:3.7 as Production
# add ca-certificates in case you need them
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
# set working directory
WORKDIR /root
# copy the binary from builder
COPY --from=builder:latest /go/src/app/main .
# run the binary
CMD ["./main"]