# Cloud Run Timestamp Application Microservices Global Scale Architecture

Google Cloud Run global scaled container Python3, Golang, Terraform, Artifact registry, bash, Cloud Build, and Cloud Storage Bucket Backend 

<b>PLEASE NOTE: The actual readme for whats deployed is https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/tree/main/terraform
This readme describes a global scaled container based version of this exercise.</b>
The purpose of this exercise was to design and deploy a timestamp generator that updates a storage object in a storage bucket, every 10 minutes, and that timestamp 
be available via curl and browser.

The following web links are available for your viewing.

<b>HTTP PORT 80 URL:</b>  http://34.147.3.6/

<b>HTTPS/TLS/SSL PORT 443 URL:</b> https://timestamps.puplampu.me/

<b>HTTP PORT 80 URL:</b>  http://34.147.3.6/timestamps.html

<b>HTTPS/TLS/SSL PORT 443 URL:</b> https://timestamps.puplampu.me/timestamps.html

<b>GitHub Repo of Terraform Code:</b>  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/edit/main/terraform/

<b>GitHub Repo of the Cloud Run Global Scaled Deployment Timestamp Solution:</b>  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/tree/main

<b>STATUS:</b>  COMPLETE

■ Diagram of the above implementation:

                                +-----------------+
                                |  Internet       |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Firewall and    |
                                | NAT             |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Compute Engine  |
                                |     VM          |
                                | (Web Server)    |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Cloud Storage   |
                                |      Bucket     |
                                +-----------------+

## Prerequisite

* Cloud Run API build pipeline via the [console](https://console.cloud.google.com/apis/library/run.googleapis.com?_ga=2.124941642.1555267850.1615248624-203055525.1615245957) or CLI:

```bash
gcloud services enable run.googleapis.com
```

## Application Stack

* **Flask**: Web server framework
* **Buildpack support** Tooling to build production-ready container images from source code and without a Dockerfile
* **Dockerfile**: Container build instructions, if needed to replace buildpack for custom build
* **SIGTERM handler**: Catch termination signal for cleanup before Cloud Run stops the container
* **Service metadata**: Access service metadata, project ID and region, at runtime
* **Local development utilities**: Auto-restart with changes and prettify logs
* **Structured logging w/ Log Correlation** JSON formatted logger, parsable by Cloud Logging, with [automatic correlation of container logs to a request log](https://cloud.google.com/run/docs/logging#correlate-logs).
* **Unit and System tests**: Basic unit and system tests setup for the microservice
* **Task definition and execution**: Uses [invoke](http://www.pyinvoke.org/) to execute defined tasks in `tasks.py`.

## Local Development

### Cloud Code

Repository code reference sources: [Cloud Code](https://cloud.google.com/code), an IDE extension
to let you rapidly iterate, debug, and run code on Kubernetes and Cloud Run.

Google Cloud Code for:

* Local development - [VSCode](https://cloud.google.com/code/docs/vscode/developing-a-cloud-run-service), [IntelliJ](https://cloud.google.com/code/docs/intellij/developing-a-cloud-run-service)

* Local debugging - [VSCode](https://cloud.google.com/code/docs/vscode/debugging-a-cloud-run-service), [IntelliJ](https://cloud.google.com/code/docs/intellij/debugging-a-cloud-run-service)

* Deploying a Cloud Run service - [VSCode](https://cloud.google.com/code/docs/vscode/deploying-a-cloud-run-service), [IntelliJ](https://cloud.google.com/code/docs/intellij/deploying-a-cloud-run-service)
* Creating a new application from a custom template (`.template/templates.json` allows for use as an app template) - [VSCode](https://cloud.google.com/code/docs/vscode/create-app-from-custom-template), [IntelliJ](https://cloud.google.com/code/docs/intellij/create-app-from-custom-template)

### CLI Instructions

To run the `invoke` commands below, install [`invoke`](https://www.pyinvoke.org/index.html) system wide: 

```bash
pip install invoke
```

Invoke will handle establishing local virtual environments, etc. Task definitions can be found in `tasks.py`.

#### Local development

1. Set Project Id:
    ```bash
    export GOOGLE_CLOUD_PROJECT=<GCP_PROJECT_ID>
    ```
2. Start the server with hot reload:
    ```bash
    invoke dev
    ```

#### Instructions to deploy the Cloud Run service

1. Set Project Id:
    ```bash
    export GOOGLE_CLOUD_PROJECT=<GCP_PROJECT_ID>
    ```

1. Enable the Artifact Registry API:
    ```bash
    gcloud services enable artifactregistry.googleapis.com
    ```

1. Create an Artifact Registry repo:
    ```bash
    export REPOSITORY="samples"
    export REGION=us-central1
    gcloud artifacts repositories create $REPOSITORY --location $REGION --repository-format "docker"
    ```
  
1. Use the gcloud credential helper to authorize Docker to push to your Artifact Registry:
    ```bash
    gcloud auth configure-docker
    ```

2. Build the container using a buildpack:
    ```bash
    invoke build
    ```
3. Deploy to Cloud Run:
    ```bash
    invoke deploy
    ```

### Run sample tests

1. [Pass credentials via `GOOGLE_APPLICATION_CREDENTIALS` env var](https://cloud.google.com/docs/authentication/production#passing_variable):
    ```bash
    export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
    ```

2. Set Project Id:
    ```bash
    export GOOGLE_CLOUD_PROJECT=<GCP_PROJECT_ID>
    ```
3. Run unit tests
    ```bash
    invoke test
    ```

4. Run system tests
    ```bash
    gcloud builds submit \
        --config test/advance.cloudbuild.yaml \
        --substitutions 'COMMIT_SHA=manual,REPO_NAME=manual'
    ```
    The Cloud Build configuration file will build and deploy the containerized service
    to Cloud Run, run tests managed by pytest, then clean up testing resources. This configuration restricts public
    access to the test service. Therefore, service accounts need to have the permission to issue ID tokens for request authorization:
    * Enable Cloud Run, Cloud Build, Artifact Registry, and IAM APIs:
        ```bash
        gcloud services enable run.googleapis.com cloudbuild.googleapis.com iamcredentials.googleapis.com artifactregistry.googleapis.com
        ```
        
    * Set environment variables.
        ```bash
        export PROJECT_ID="$(gcloud config get-value project)"
        export PROJECT_NUMBER="$(gcloud projects describe $(gcloud config get-value project) --format='value(projectNumber)')"
        ```

    * Create an Artifact Registry repo (or use another already created repo):
        ```bash
        export REPOSITORY="samples"
        export REGION=us-central1
        gcloud artifacts repositories create $REPOSITORY --location $REGION --repository-format "docker"
        ```
  
    * Create service account `token-creator` with `Service Account Token Creator` and `Cloud Run Invoker` roles.
        ```bash
        gcloud iam service-accounts create token-creator

        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:token-creator@$PROJECT_ID.iam.gserviceaccount.com" \
            --role="roles/iam.serviceAccountTokenCreator"
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:token-creator@$PROJECT_ID.iam.gserviceaccount.com" \
            --role="roles/run.invoker"
        ```

    * Add `Service Account Token Creator` role to the Cloud Build service account.
        ```bash
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
            --role="roles/iam.serviceAccountTokenCreator"
        ```
    
    * Cloud Build also requires permission to deploy Cloud Run services and administer artifacts: 

        ```bash
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
            --role="roles/run.admin"
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
            --role="roles/iam.serviceAccountUser"
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
            --role="roles/artifactregistry.repoAdmin"
        ```



## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
