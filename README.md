# kubecf-pipelines
Repo to automate the deployment of [KubeCF](https://kubecf.io/docs/) on Google Cloud. Deploys a GKE cluster with autoscaling, with a KubeCF environment with a signed Let's Encrypt TLS certificate covering its wildcard domain.

## Deploy a new environment
### Prerequisites
This pipeline expects a GCP project with the service usage API enabled to exist along with credentials for a user that has the following roles:

- roles/owner
- roles/container.admin
- roles/storage.admin

There should also be a GCS bucket created to store the Terraform state and a Cloud DNS zone correctly delegated for your nominated domain.

### Credentials
The following credentials should be available from either a Concourse secrets backend or a private vars file:
```yaml
gcp_credentials_json: {} # JSON credentials file for user created in prerequisite steps
terraform_backend_bucket: my-bucket # name of bucket created in prerequisite step
```

### Variables
The following variables are required for the pipeline

```yaml
domain: # domain of Cloud DNS zone created in prerequisite step
dns_zone_name: # name of Cloud DNS zone created in prerequisite step
gcp_project_id: # ID of project
region: europe-west2 # or other region
node_counts_per_zone: # used for k8s node autoscaling
  min: 1
  max: 1
```

## Accessing KubeCF

In order to do a `cf login` you first need to authenticate with your GKE cluster. You can do so with the following `gcloud` command:

```
$ gcloud container clusters get-credentials kubecf --region europe-west2 --project <project-id>
```

Next retrieve the KubeCF admin password, which is stored as a Kubernetes secret:

```
$ kubectl get secret var-cf-admin-password --namespace kubecf --output=jsonpath='{.data.password}' | base64 --decode
```

Now login to KubeCF (get the value of 'domain' from your variables file in /vars):

```
$ cf login -a https://api.<domain> -u admin -p <password>
```
