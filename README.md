This guide provides instructions on how to set up a complete project in GCP.

## Step 1: Authenticate with Google Cloud:
Use the following command to authenticate your local environment with your Google Cloud account:

    gcloud auth login

This command will open a web browser where you can log in with your Google account.

After authentication, set your active Google Cloud project by running:

    gcloud config set project YOUR_GCP_PROJECT_ID

Replace YOUR_GCP_PROJECT_ID with your actual Google Cloud project ID.  

## Creating and Configuring the Service Account using gcloud commands.

## Step 2: Create the Service Account

Use the following gcloud command to create a new service account:

    gcloud iam service-accounts create terraform \
    --display-name="terraform"
    
## Step 3: Assign IAM Role Permissions

Assign the required IAM roles to the service account with the following command:     
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/compute.admin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/compute.storageAdmin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/editor"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/container.admin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/monitoring.viewer"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/secretmanager.admin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/secretmanager.secretAccessor"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/iam.securityAdmin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/vpcaccess.admin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/iam.serviceAccountAdmin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/storage.admin"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/iam.workloadIdentityUser"
    
    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member="serviceAccount:terraform@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com" \
      --role="roles/servicenetworking.networksAdmin"



## Step 4: Generate the Service Account Key
  
Generate the service account key and save it to a JSON file:
    
    gcloud iam service-accounts keys create ./secret.json \
    --iam-account=terraform@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com

After generating the new key, activate the service account using:

    gcloud auth activate-service-account --key-file=secret.json

Step 5: Create a Bucket for Storing the Terraform State File

    gcloud storage buckets create gs://NAME-OF-YOUR-GCP-BUCKET --location=us-central1

Remember, the bucket name must be globally unique. After creating the bucket, replace the bucket name in the terraform backend section within the main.tf file.

Step 6: Creating Infrastructure in GCP using Terraform

    terraform init
    terraform plan -var="projectName=YOUR_GCP_PROJECT_ID"
    terraform apply -var="projectName=YOUR_GCP_PROJECT_ID" -auto-approve
 
Step 7: Workload Identity setup

    gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project YOUR_GCP_PROJECT_ID

    kubectl create serviceaccount gke-sa --namespace=default

    gcloud iam service-accounts add-iam-policy-binding gke-sa@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$YOUR_GCP_PROJECT_ID.svc.id.goog[default/gke-sa]"
    
    kubectl annotate serviceaccount gke-sa \
    --namespace default \
    iam.gke.io/gcp-service-account=gke-sa@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com
    
Step 8: Fetch and saving the private IP address of the Cloud SQL instance to GCP secrets

    gcloud secrets versions add DB_HOST --data-file=<(gcloud sql instances describe disearch-db --format="json(ipAddresses)" | jq -r '.ipAddresses[] | select(.type == "PRIVATE") | .ipAddress')

