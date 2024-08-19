#  _______                   __                        _____ _        _
# |__   __|                 / _|                      / ____| |      | |
#    | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___   | (___ | |_ __ _| |_ ___
#    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \   \___ \| __/ _` | __/ _ \
#    | |  __/ |  | | | (_| | || (_) | |  | | | | | |  ____) | || (_| | ||  __/
#    |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| |_____/ \__\__,_|\__\___|

# Creating Bucket for Storing Terraform State. If exist then skip to next step.
TF_BUCKET_SECRET_NAME="terraform_state"
EXISTING_TF_SECRET=$(gcloud secrets list --filter="name:$TF_BUCKET_SECRET_NAME" --format="value(name)")

if [ -n "$EXISTING_TF_SECRET" ]; then
  echo "Secret '$TF_BUCKET_SECRET_NAME' already exists. Skipping bucket creation."
  # Retrieve the bucket name from the existing secret
  TF_STATE_BUCKET_NAME=$(gcloud secrets versions access latest --secret="$TF_BUCKET_SECRET_NAME")
  echo "Bucket name retrieved from secret: $TF_STATE_BUCKET_NAME"
else
  # Generate a random string
  RANDOM_STRING=$(head /dev/urandom | tr -dc a-z0-9 | head -c 8)

  # Combine the base bucket name with the random string
  TF_STATE_BUCKET_NAME="terraform-state-$RANDOM_STRING"

  # Create the bucket
  echo "Creating bucket: gs://$TF_STATE_BUCKET_NAME"
  gcloud storage buckets create gs://$TF_STATE_BUCKET_NAME --location=$REGION

  # Create the secret and save the bucket name in it
  echo "Creating secret '$TF_BUCKET_SECRET_NAME' and saving the bucket name in it."
  echo -n "$TF_STATE_BUCKET_NAME" | gcloud secrets create $TF_BUCKET_SECRET_NAME --data-file=-

  # Add a new version of the secret with the bucket name
  echo -n "$TF_STATE_BUCKET_NAME" | gcloud secrets versions add $TF_BUCKET_SECRET_NAME --data-file=-
fi

sed -i "s/TF_BACKEND_BUCKET_NAME/$TF_STATE_BUCKET_NAME/g" main.tf
echo "Done."
