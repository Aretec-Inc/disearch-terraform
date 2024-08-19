This guide provides instructions on how to run Deployer images in a Cloud Run job with the necessary environment variables and how to create and configure a service account with the required IAM role permissions.


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
    
    gcloud iam service-accounts keys create ~/key-file.json \
    --iam-account=terraform@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com

The key file will be saved to ~/key-file.json. 

After generating the new key, activate the service account using:

    cd ~ && gcloud auth activate-service-account --key-file=key-file.json

## Step 5: Creating Secrets in GCP Secret Manager

Use gcloud command for creating secrets in GCP Secret Manager

    gcloud secrets create PROJECT_ID --replication-policy="automatic"
    gcloud secrets create PROJECT_NUMBER --replication-policy="automatic"
    gcloud secrets create DEFAULT_OWNER_EMAIL --replication-policy="automatic"
    gcloud secrets create WEBSITE_URL --replication-policy="automatic"
    gcloud secrets create SERVICE_ACCOUNT_KEY --replication-policy="automatic"

After creating the secrets, you can add the actual values to them by adding secret versions. 

    echo -n "your-project-id" | gcloud secrets versions add PROJECT_ID --data-file=-
    echo -n "your-project-number" | gcloud secrets versions add PROJECT_NUMBER --data-file=-
    echo -n "your-owner-email@example.com" | gcloud secrets versions add DEFAULT_OWNER_EMAIL --data-file=-
    echo -n "your-website-url.com" | gcloud secrets versions add WEBSITE_URL --data-file=-
    echo -n "$(cat ~/key-file.json)" | gcloud secrets versions add SERVICE_ACCOUNT_KEY --data-file=-

## Step 6: Create and Execute Cloud Run Job

      gcloud run jobs create deployer \
        --image=gcr.io/aretecinc-public/disearch/deployer/deployer:1.0 \
        --region=us-central1 \
        --service-account=terraform@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com \
        --set-secrets=PROJECT_ID=PROJECT_ID:latest,PROJECT_NUMBER=PROJECT_NUMBER:latest,DEFAULT_OWNER_EMAIL=DEFAULT_OWNER_EMAIL:latest,WEBSITE_URL=WEBSITE_URL:latest,SERVICE_ACCOUNT_KEY=SERVICE_ACCOUNT_KEY:latest \
        --memory=512Mi \
        --cpu=1 \
        --task-timeout=3h \
        --max-retries=1 \
        --parallelism=1
  

      gcloud run jobs execute deployer --region us-central1


By following these steps, you've successfully configured your environment and service account to run your Cloud      Run job. Ensure all environment variables are set before executing the job.
    
    
