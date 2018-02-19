# Example of Vendor-ed Golang web app using Glide

Setup of [Glide](https://glide.sh/) in the Docker is done at the time of building the image.

However the dependncies are installed at a later time.

The example go program uses the https://github.com/julienschmidt/httprouter which is inserted using the **Glide** Package management

Here the steps:

  1. First run the `build-docker.sh` to generate the build image

  2. Add the 2 special files `glide.yaml` and `glide.lock` into the project root. They have been already added for this example.

  3. Add the `vendor` directory to `.dockerignore` file and `.gitignore` files. This also has been completed in the current example.

  4. Next run a `bash` shell into the built docker image in order to add the dependencies. To do this use the script `run-docker-bash.sh`. 

  **Note:** This would only work if the previous docker buld was successful.

  5. Finally install the depency by the following command:

  ```shell
  glide get github.com/julienschmidt/httprouter
  ```

  This step is already done and hence the `glide.yaml` and `glide.lock` have already been update.

  6. Now in the same shell to run the program use the command

  ```shell
  go run src/main.go
  ```

  This would execute the program with the dependencies included.


At this point one can also try running the full container app by using the script `run-docker-app.sh`


Make sure to build the docker image again in case you have made any changes by executing the script `build-docker.sh`


**Note**: In both cases the port used by application is `:8080` which needs to be mapped.