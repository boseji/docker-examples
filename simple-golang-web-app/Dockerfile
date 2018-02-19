from golang:1.8 as devmachine
# Create the Working Directory
WORKDIR /go/src/app
# Add the source directory
ADD src src
# Run the Go file
CMD ["go", "run", "src/main.go"]