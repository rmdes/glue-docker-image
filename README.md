# glue-docker-image

This is the docker image we use to debug and test our [AWS Glue](https://aws.amazon.com/glue/) scripts locally in development, and run in CI.

# Background

AWS publishes a [docker image to docker hub](https://hub.docker.com/r/amazon/aws-glue-libs) but currently this seems to be more focussed on interactive users as it it defaults to running jupyter and not testing or debugging.

There is no source code or any github repo for this resource, and the team is not very attentive to AWS tickets, so for this reason we open sourced this repository.

Hopefully this helps others in testing their glue jobs, and debugging code in vscode.

# How did we build this image?

This image is just using the same instructions as AWS provides to [install glue locally on your workstation](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html).

# Release Process

1. PRs are created and merged to master, note these have no docker tag.
2. PRs are merged into master and can be accessed from ghcr under the `master` tag.
3. Once the image is integration tested we make a release by pushing a tag eg. `v1.0.0` and do a release.

**Note:** The release version is prefixed with the glue version.

# Licensing

The code in this repository is released under Apache 2.0 License.