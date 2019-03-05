# Cloud Build service for building Docker Images

We would be using the [**Google Cloud Container Builder**](https://cloud.google.com/container-builder/) service to create and download our docker image.

We would first need to create a small application that can show us some text as soon as the container is created. This is similar to the docker hub [**hello-world**](https://hub.docker.com/_/hello-world/) image.

## Shell script to Print a message

The following is a shell script that would be used run by the docker container:

```bash
#!/bin/sh
echo "Hari Aum! The time is $(date)."
```

Make sure to change permission the script to make it executable

`chmod +x script.sh`

## Dockerfile for the Image

```Dockerfile
FROM alpine
COPY script.sh /
CMD ["/script.sh"]
```

This simple docker file would create an Image using `alpine` linux at its core.

And would run our script at boot time.

## Instructing the Builder with `cloudbuild.yaml` File

```yaml
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/hello-image', '.' ]
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'save', '-o', 'hello-image.tar.gz', 'gcr.io/$PROJECT_ID/hello-image' ]
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'rmi', 'gcr.io/$PROJECT_ID/hello-image']
- name: 'gcr.io/cloud-builders/gsutil'
  args: ['-m', 'cp', 'hello-image.tar.gz', 'gs://svr1-go-build/']
```

Here we are first creating the Image using the `docker build` command.

Then we proceed to create the Image file out of the built docker image.

Next we remove the image from the registry of docker.

Finally we are copying back the image into our Storage bucket.

## Initiate the Image Build

Make sure to follow the earlier steps to [get to the google/cloud-sdk console](https://github.com/boseji/dockerPlayground/tree/master/12_go_google_cloud_compile#initiating-the-upload)

`gcloud builds submit --config cloudbuild.yaml .`

## Restoring the Image

After downloading the file `hello-image.tar` from the Storage Bucket, give this command
to install it into the local docker image registry.

`docker load -i hello-image.tar`

You can now see it as :

`hello-image:latest` 

in the Images list by giving the command : `docker images`

Now we can check this image by running

`docker run --rm hello-image:latest`