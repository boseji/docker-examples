# Google Cloud Build - Golang Project

[**Google Cloud platform**](https://cloud.google.com/container-builder/) has introduced the ***Container Builder*** service.

Interestingly this service also provides a way to compile *golang* projects on the cloud.

The source code gets uploaded to a Storage bucket and then complied into the binary of the required operating system.

Finally the binary file is copied back into the previously created Storage Bucket and then available for download.

## Getting the Google Cloud SDK image

```shell
docker pull google/cloud-sdk
```

This is the Image contains the complete SDK with all the required tools into a *Ubuntu* image.

We would use this image interactively to load compile and download our *golang* project.

## Creating a basic Golang app

We have created an app that would print the customary *Hello World!*.

This is available in the `gosrc` folder:

```go
package main

import (
    "fmt"
)

func main() {
    fmt.Println("Hello, world!")
}
```

## Creating the `cloudbuild.yaml` file

The file that governs the way the **Cloud Builder** would work towards creating our *golang* application is `cloudbuild.yaml`

In our case we have this in the same `gosrc` folder:

[**`cloudbuild.yaml`**](https://github.com/boseji/dockerPlayground/blob/master/12_go_google_cloud_compile/gosrc/cloudbuild.yaml) 

```yaml
steps:
- name: 'gcr.io/cloud-builders/go'
  args: ['install', '.']
  env: ['PROJECT_ROOT=hello']
- name: 'gcr.io/cloud-builders/go'
  args: ['build', 'hello']
  env: ['PROJECT_ROOT=hello']
- name: 'gcr.io/cloud-builders/gsutil'
  args: ['-m', 'cp', 'hello', 'gs://svr1-go-build/']
```

Lets look at whats happening here:

1. First we call the `go install .` command from `gcr.io/cloud-builders/go` this would get all the dependencies installed and compiled.

Also note that we make sure that our project output is configured. This is typically the output file name and the source location. By default this is built by the **Cloud Builder** as another Storage bucket, into which our source code gets uploaded. Hence in this case `PROJECT_ROOT=hello` environment configuration is to help the compiler know we wish to have our executable named as `hello` in this step.

2. Next we initiate the build of our *golang* program. Assuming `GOOS=linux` we only set the name `PROJECT_ROOT=hello` and use the same in the building command `go build hello`.

3. Finally we want to copy the built image to our Storage bucket so we use the `gsutil` command. Here `svr1-go-build` is a bucket we created earlier.

That was the explanation of this `cloudbuild.yaml` file which provides instruction to perform the build to **Cloud Build** service.

## Initiating the Upload

### Step 1: Create a Login Instance of GCP `google/cloud-sdk` image

```shell
docker run -ti --name gcloud-config google/cloud-sdk gcloud auth login
```
This would guide us for login by providing a URL.

Copy the URL to our browser, login and copy back the authorization code to the terminal.

### Step 2: We create the interactive instance of the `google/cloud-sdk` image

```shell
docker run --rm -ti --volumes-from gcloud-config -v "$(pwd)":/gosrc google/cloud-sdk
```
Here we are mounting the local folder `gosrc` so that we can use it inside the container `some-gcp`.

The use of `--volumes-from gcloud-config` helps us get the credenetials

### Step 3: Set GCP Project context

Next we set the correct project:

```shell
gcloud config set project <PROJECT-ID>
```

### Additional Step to create the Cloud Storage Bucket

```shell
gsutil mb gs://svr1-go-build
```

This command would help to create the buck where our built executable would reside.

### Step 4: Initiate the upload

Now we are though with the environment configuration. We would now go to the correct
directory to initiate the upload:

```shell
cd /gosrc
gcloud builds submit --config cloudbuild.yaml
```

This initiates the upload and asks the **Cloud Build** service to begin executing our commands specified in the `cloudbuild.yaml` file.


## References:

https://www.ianlewis.org/en/building-go-applications-google-container-builder
