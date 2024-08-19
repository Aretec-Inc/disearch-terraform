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

## Step 5: Create a Bucket for Storing the Terraform State File

    gcloud storage buckets create gs://NAME-OF-YOUR-GCP-BUCKET --location=us-central1

Remember, the bucket name must be globally unique. After creating the bucket, replace the bucket name in the terraform backend section within the main.tf file.

## Step 6: Creating Infrastructure in GCP using Terraform

    terraform init
    terraform plan -var="projectName=YOUR_GCP_PROJECT_ID"
    terraform apply -var="projectName=YOUR_GCP_PROJECT_ID" -auto-approve
 
## Step 7: Workload Identity setup

Connecting the cluster 

    gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project YOUR_GCP_PROJECT_ID

    kubectl create serviceaccount gke-sa --namespace=default

    gcloud iam service-accounts add-iam-policy-binding gke-sa@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$YOUR_GCP_PROJECT_ID.svc.id.goog[default/gke-sa]"
    
    kubectl annotate serviceaccount gke-sa \
    --namespace default \
    iam.gke.io/gcp-service-account=gke-sa@YOUR_GCP_PROJECT_ID.iam.gserviceaccount.com
    
## Step 8: Fetch and saving the private IP address of the Cloud SQL instance to GCP secrets

    gcloud secrets versions add DB_HOST --data-file=<(gcloud sql instances describe disearch-db --format="json(ipAddresses)" | jq -r '.ipAddresses[] | select(.type == "PRIVATE") | .ipAddress')

## Step 9: Creating Postgres Connection String 

    ENCODED_CONN_STRING=$(echo -n "postgresql://postgres:$(gcloud secrets versions access latest --secret=DB_PASSWORD)@$(gcloud secrets versions access latest --secret=DB_HOST)/postgres" | base64 -w 0)

Use below commands for Verificaiton

    echo "ENCODED_CONN_STRING: $(echo "$ENCODED_CONN_STRING" | base64 --decode)"

## Step 10: Adding Helm Charts on Google kubernetes Engine

    helm repo add aretec-public https://aretec-inc.github.io/disearch-helm/
    helm repo add kedacore https://kedacore.github.io/charts
    helm repo update
    helm show values aretec-public/gke-templates > gke-values.yaml
    helm show values aretec-public/redis > redis-values.yaml
    helm show values aretec-public/etcd > etcd-values.yaml
 
    gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project YOUR_GCP_PROJECT_ID

## Step 11: Fetch and Replacing Values in values.yaml

Fetch private endpoint of Cluster
    
    echo "INTERNAL_ENDPOINT: $(echo -n "https://$(gcloud container clusters describe disearch-cluster --zone us-central1-c --format="get(privateClusterConfig.privateEndpoint)")" | base64)"

    
Decode the base64 encoded endpoint for verfication

    echo "Decoded INTERNAL_ENDPOINT: $(echo "$INTERNAL_ENDPOINT" | base64 --decode)"

Replace Values
    
    sed -i "s|REPLACE_WITH_PROJECT_ID|aretecinc-public|g" gke-values.yaml
    
    sed -i "s|REPLACE_WITH_KUBEAPI_SERVER_URL|$INTERNAL_ENDPOINT|g" gke-values.yaml
    echo "Updated gke-values.yaml with the internal endpoint URL."
    
    sed -i "s/REPLACE_SQL_DB_CONNECTION/$ENCODED_CONN_STRING/g" gke-values.yaml
    echo "Updated gke-values.yaml with the database connection string."
    
    sed -i "s|REPLACE_WITH_DOCUMENT_STATUS_CF_URL|https://us-central1-YOUR_GCP_PROJECT_ID.cloudfunctions.net/document-status|g" gke-values.yaml
    echo "Updated gke-values.yaml with the Document Status CF URL."
    
    sed -i "s|REPLACE_WITH_IMAGE_PROCESSING_CF_URL|https://us-central1-YOUR_GCP_PROJECT_ID.cloudfunctions.net/image-processing|g" gke-values.yaml
    echo "Updated gke-values.yaml with the Document Status CF URL."
    
    sed -i "s|REPLACE_WITH_UPDATE_METADATA_INJECTED_DOCUMENT|https://us-central1-YOUR_GCP_PROJECT_ID.cloudfunctions.net/update_metadata_ingested_document|g" gke-values.yaml
    echo "Updated gke-values.yaml with the Document Status CF URL."
    
    sed -i "s|REPLACE_WITH_PASSWORD|UmVkaXMxMjMkJV4uLg==|g" redis-values.yaml
    echo "Updated Redis password in redis-values.yaml."

Appling Helm upgrade Commands

    helm upgrade --install keda kedacore/keda --namespace keda --create-namespace
    helm upgrade --install gke-templates aretec-public/gke-templates --values ./gke-values.yaml
    helm upgrade --install redis aretec-public/redis --values ./redis-values.yaml
    helm upgrade --install etcd aretec-public/etcd --values ./etcd-values.yaml

## Step 12: Cloud Function Deployments

    BUCKET_NAME=$(gcloud secrets versions access latest --secret="GCP_BUCKET") && echo "Bucket name: $BUCKET_NAME"

Clone the GitHub repository. 

Email at aareez.asif@aretecinc.com to get the authentication token for pulling the cloud functions from the repository.

    git clone https://PASTE_AUTHENTICATION_TOKEN_HERE@github.com/Aretec-Inc/uploader-trigger-cf.git
    git clone https://PASTE_AUTHENTICATION_TOKEN_HERE@github.com/Aretec-Inc/document-status-cf.git
    git clone https://PASTE_AUTHENTICATION_TOKEN_HERE@github.com/Aretec-Inc/image-process-cf.git
    git clone https://PASTE_AUTHENTICATION_TOKEN_HERE@github.com/Aretec-Inc/metadata-extractor-cf.git
    git clone https://PASTE_AUTHENTICATION_TOKEN_HERE@github.com/Aretec-Inc/pdf-convert-cf.git

Email at aareez.asif@aretecinc.com to get the authentication token for pulling the cloud functions from the repository.

Appling Policy
    
    GCS_SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p "YOUR_GCP_PROJECT_NUMBER") && echo "GCS_SERVICE_ACCOUNT: $GCS_SERVICE_ACCOUNT"

    gcloud projects add-iam-policy-binding "YOUR_GCP_PROJECT_ID" \
      --member serviceAccount:$GCS_SERVICE_ACCOUNT \
      --role roles/pubsub.publisher

Cloud Functions

Deploying Cloud Function uploader-trigger

    echo "Deploying uploader-trigger"
    cd uploader-trigger-cf
    git checkout deployment
    gcloud functions deploy uploader-trigger \
      --runtime python39 \
      --entry-point main_func \
      --set-env-vars=LOG_EXECUTION_ID=true \
      --set-secrets=bucket=projects/$PROJECT_ID/secrets/GCP_BUCKET:latest,project_id=projects/"YOUR_GCP_PROJECT_ID"/secrets/project_id:latest \
      --service-account gke-sa@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com \
      --serve-all-traffic-latest-revision \
      --vpc-connector disearch-vpc-connector \
      --trigger-bucket $BUCKET_NAME \
      --region us-central1 \
      --gen2 \
      --quiet
    cd ..
    
Deploying Cloud Function document-status

    echo "Deploying document-status"
    cd document-status-cf
    git checkout deployment
    gcloud functions deploy document-status \
      --runtime python39 \
      --trigger-http \
      --entry-point main_func \
      --set-secrets 'DB_HOST=DB_HOST:latest,DB_USER=DB_USER:latest,DB_PASSWORD=DB_PASSWORD:latest' \
      --service-account  gke-sa@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com \
      --serve-all-traffic-latest-revision \
      --vpc-connector disearch-vpc-connector \
      --region us-central1 \
      --gen2 \
      --quiet
    cd ..

Deploying Cloud Function image-processing

    echo "Deploying image-processing"
    cd image-process-cf
    git checkout deployment
    gcloud functions deploy image-processing \
      --runtime python39 \
      --entry-point main_func \
      --service-account  gke-sa@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com \
      --set-env-vars=SCHEMA=disearch_search,LOG_EXECUTION_ID=true \
      --set-secrets 'LOG_INDEX=LOG_INDEX:latest,LOGS_URL=LOGS_URL:latest,gpt_key=OPENAI_API_KEY:latest' \
      --vpc-connector disearch-vpc-connector \
      --serve-all-traffic-latest-revision \
      --trigger-http \
      --gen2 \
      --region us-central1 \
      --memory 2G
    cd ..  

Deploying Cloud Function Metadata Extractor
    
    echo "Deploying Metadata Extractor"
    cd metadata-extractor-cf
    git checkout deployment
    gcloud functions deploy update_metadata_ingested_document \
      --runtime python39 \
      --trigger-http \
      --entry-point main_func \
      --set-env-vars=LOG_EXECUTION_ID=true \
      --set-secrets=project_id=projects/$PROJECT_ID/secrets/project_id:latest \
      --service-account gke-sa@"YOUR_GCP_PROJECT_ID".iam.gserviceaccount.com \
      --vpc-connector disearch-vpc-connector --region us-central1 --serve-all-traffic-latest-revision --gen2 --memory 1G
    cd ..

## Step 13: Fetching and updating Cloudfunction URL's in GCP Secrets

    gcloud secrets versions add status_cloud_fn --data-file=<(echo -n "$(gcloud functions describe document-status --region=us-central1 --format="value(url)")") --project="YOUR_GCP_PROJECT_ID"

    gcloud secrets versions add image_summary_cloud_fn --data-file=<(echo -n "$(gcloud functions describe image-processing --region=us-central1 --format="value(url)")") --project="YOUR_GCP_PROJECT_ID"
        
    gcloud secrets versions add metadata_cloud_fn --data-file=<(echo -n "$(gcloud functions describe update_metadata_ingested_document --region=us-central1 --format="value(url)")") --project="YOUR_GCP_PROJECT_ID"

## Step 14: Creating Pubsub and subscriptions

Creating and listing pubsub topic

    gcloud pubsub topics create file-process-topic
    gcloud pubsub topics create image-topic
    gcloud pubsub topics create metadata-topic
    gcloud pubsub topics create pdf-convert-topic
    gcloud pubsub topics create dead-letter-topic
    gcloud pubsub topics list

Creating Pubsub Subscriptions

    gcloud pubsub subscriptions create file-process-subscription \
        --topic=file-process-topic \
        --message-retention-duration=7d \
        --expiration-period=31d \
        --ack-deadline=600
    
    
    gcloud pubsub subscriptions create image-subscription \
        --topic=image-topic \
        --message-retention-duration=7d \
        --expiration-period=31d \
        --ack-deadline=600
    
    
    gcloud pubsub subscriptions create metadata-subscription \
        --topic=metadata-topic \
        --message-retention-duration=7d \
        --expiration-period=31d \
        --ack-deadline=600
    
    
    gcloud pubsub subscriptions create pdf-subscription \
        --topic=pdf-convert-topic \
        --message-retention-duration=7d \
        --expiration-period=31d \
        --ack-deadline=600
## Step 15: Fetching and updating GKE variables in GCP secrets

Connecting the cluster

    gcloud container clusters get-credentials disearch-cluster --zone us-central1-c --project YOUR_GCP_PROJECT_ID

    kubectl get service doc-chat-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add DOCUMENT_CHAT_URL --data-file=-
    
    kubectl get service vertex-ai-followup-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add vertexai_followup --data-file=-
    
    kubectl get service vertexai-citation-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add vertexai_citation --data-file=-
    
    kubectl get service vertexai-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add vertexai_python_url --data-file=-
    
    kubectl get service vertexai-summary-service -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add vertexai-summary --data-file=-
    
    kubectl get service pdflb -o=jsonpath='http://{.status.loadBalancer.ingress[0].ip}' | gcloud secrets versions add pdf_loadbalancer --data-file=-

## Step 16: Updating GCP Secret for Website URL

       echo -n "YOUR_WEBSITE_URL" | gcloud secrets versions add vertexai-referer --data-file=- --project=YOUR_GCP_PROJECT_ID

Make sure to add the Website URL here.
