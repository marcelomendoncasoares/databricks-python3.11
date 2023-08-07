# databricks-python3.11
A custom version of the latest Databricks runtime that replaces Python 3.10 by 3.11.

## How to build and run

To build, run the commands below:

```bash
docker build -t marcelomendoncasoares/databricksruntime-python3.11:latest .
docker run -i --rm -t marcelomendoncasoares/databricksruntime-python3.11:latest
```

## How to push

To publish the image, run:

```bash
docker push marcelomendoncasoares/databricksruntime-python3.11:latest
```

## How to use

Refer to the [official documentation page](https://docs.databricks.com/clusters/custom-containers.html) on how to use custom Databricks images.

> Remember to first enable `Container Services` on Databricks `Admin Console > Workspace Settings` to be able to specify custom docker images to a cluster as runtime.
