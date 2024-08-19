terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.82.0"
    }
    kubernetes = {
      source  = "hashicorp/helm"
      version = "2.11.0"
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14.0"
    }
  }

  backend "gcs" {
    bucket = "TF_BACKEND_BUCKET_NAME"
    prefix = "terraform/state"
}
}


provider "google" {
  project     = var.projectName
  region      = var.region
  credentials = file("./secret.json")
}



//SERVICESSS START HERE

resource "google_project_service" "enable_cloudbuild" {
  project = var.projectName
  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_containerregistry" {
  project = var.projectName
  service = "containerregistry.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_secretmanager" {
  project = var.projectName
  service = "secretmanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_naturallanguage" {
  project = var.projectName
  service = "language.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_servicenetworking" {
  project = var.projectName
  service = "servicenetworking.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_sqladmin" {
  project = var.projectName
  service = "sqladmin.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_run" {
  project = var.projectName
  service = "run.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_cloudresourcemanager" {
  project = var.projectName
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_iamcredentials" {
  project = var.projectName
  service = "iamcredentials.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "disable_all_services" {
  project = var.projectName
  service = "iam.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_container" {
  project = var.projectName
  service = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_documentai" {
  project = var.projectName
  service = "documentai.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project = var.projectName
  service = "storage.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project = var.projectName
  service = "storage-component.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_compute" {
  project = var.projectName
  service = "compute.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "enable_vpcaccess" {
  project = var.projectName
  service = "vpcaccess.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "service_usage" {
  project = var.projectName
  service = "serviceusage.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "secret_manager_api" {
  project = var.projectName
  service = "secretmanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "ai_platform_api" {
  project = var.projectName
  service = "aiplatform.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloud_function_api" {
  project = var.projectName
  service = "cloudfunctions.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloud_build_api" {
  project = var.projectName
  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "monitoring_api" {
  project = var.projectName
  service = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "eventarc" {
  project = var.projectName
  service = "eventarc.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "eventarc_publishing_api" {
  project = var.projectName
  service = "eventarcpublishing.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "dialogflow" {
  project = var.projectName
  service = "dialogflow.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "dataplex" {
  project = var.projectName
  service = "dataplex.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "datastore" {
  project = var.projectName
  service = "datastore.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "sql_component" {
  project = var.projectName
  service = "sql-component.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "null_resource" "global_delay" {
  provisioner "local-exec" {
    command = "sleep 300" # Wait 5 minutes
  }

  depends_on = [
    google_project_service.enable_cloudbuild,
    google_project_service.enable_containerregistry,
    google_project_service.enable_secretmanager,
    google_project_service.enable_naturallanguage,
    google_project_service.enable_servicenetworking,
    google_project_service.enable_sqladmin,
    google_project_service.enable_run,
    google_project_service.enable_cloudresourcemanager,
    google_project_service.enable_iamcredentials,
    google_project_service.disable_all_services,
    google_project_service.enable_container,
    google_project_service.enable_documentai,
    google_project_service.storage_api,
    google_project_service.storage,
    google_project_service.enable_compute,
    google_project_service.enable_vpcaccess,
    google_project_service.service_usage,
    google_project_service.secret_manager_api,
    google_project_service.ai_platform_api,
    google_project_service.cloud_function_api,
    google_project_service.cloud_build_api,
    google_project_service.monitoring_api,
    google_project_service.eventarc,
    google_project_service.eventarc_publishing_api,
    google_project_service.dialogflow,
    google_project_service.dataplex,
    google_project_service.datastore,
    google_project_service.sql_component
  ]
} 



//SERVICES ENDS HERE-------------------------------------------------













//VPC STARTS HEREE---------------------------------------------------


resource "google_compute_global_address" "peering_address" {
  name        = "google-managed-services-default"
  # description = "peering range for Google"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "default"
  address     = "10.50.0.0"
}

resource "google_service_networking_connection" "peering_connection" {
  network                 = "default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_address.name]
  depends_on = [ google_compute_global_address.peering_address, null_resource.global_delay ]
}

resource "google_vpc_access_connector" "disearch_vpc_connector" {
  name    = "disearch-vpc-connector"
  project = var.projectName
  region  = var.region
  network = "default"
  ip_cidr_range  = "10.10.10.0/28"
  min_instances = 2
  max_instances = 4
  machine_type = "e2-micro"
  max_throughput = 500
  lifecycle {
    ignore_changes = [
      network,
      max_throughput,
      id,
    ]
  }
  depends_on = [ google_service_networking_connection.peering_connection, null_resource.global_delay  ]
}



//VPC ENDS HERE ------------------------------------------------------------------

















//SUBNETS STARTS HEREEEE ----------------------------------------------------------



resource "google_compute_subnetwork" "uscentral_disearch_vpc01_subnet1000024" {
  name          = var.subnet_name
  ip_cidr_range = "10.2.0.0/24"
  network       = "default"
  region        = var.region
  private_ip_google_access = true
  depends_on = [ google_vpc_access_connector.disearch_vpc_connector, null_resource.global_delay ]
}

resource "google_compute_subnetwork" "uscentral_disearch_vpc01_subnet1010016_gke" {
  name          = var.gke_subnet_name
  ip_cidr_range = "10.3.0.0/16"
  network       = "default"
  region        = var.region
  private_ip_google_access = true

  secondary_ip_range {
    range_name = "k8s-pod-range"
    ip_cidr_range = "10.100.0.0/16"
  }

  secondary_ip_range {
    range_name = "k8s-services-range"
    ip_cidr_range = "10.101.0.0/16"
  }
  depends_on = [ google_compute_subnetwork.uscentral_disearch_vpc01_subnet1000024, null_resource.global_delay ]

}




//SUBNETS ENDS HERE ----------------------------------------------------------------








//STORAGE STARTS HERE -------------------------------------------------------------

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}


resource "google_storage_bucket" "disearch_storage_bucket" {
  name     = "${var.storage_bucket_name}-${random_string.bucket_suffix.result}"
  project  = var.projectName
  location = var.region
  uniform_bucket_level_access = false

    depends_on = [
    google_project_service.storage_api,
    google_project_service.storage,
    null_resource.global_delay,
  ]
}



resource "google_compute_disk" "neo4j-disk" {
  name  = "pd-ssd-disk-1"
  size  = 50
  type  = "pd-ssd"
  zone  = "us-central1-c"
  depends_on = [
    google_project_service.storage_api,
    google_project_service.storage,
  ]
}

//STORAGE ENDS HERE -------------------------------------------------------------


















//DATABASE STARTS HEREE ----------------------------------------------------------




resource "google_sql_database_instance" "disearch_db_instance" {
  name             = var.db_instance_name_prefix
  database_version = var.db_version
  project          = var.projectName
  region           = var.region
  depends_on       = [google_service_networking_connection.peering_connection, null_resource.global_delay]

  // Specify the network and do not assign IP
  settings {
    tier                      = "db-custom-1-3840"  # Equivalent to 1 CPU and 3840MiB memory
    disk_size                 = var.db_instance_disk_size
    disk_autoresize           = true
    deletion_protection_enabled = true

    ip_configuration {
      ipv4_enabled                          = false
      private_network                       = "projects/${var.projectName}/global/networks/default"
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled      = true
      start_time   = "03:00"  # Start time for backups in UTC (HH:MM format)
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
  }

  deletion_protection = true
}

resource "google_sql_user" "postgres_user" {
  instance = google_sql_database_instance.disearch_db_instance.name
  name     = var.db_username
  password = var.db_password
}





//DATABASE END HEREE ----------------------------------------------------------


//WORKLOAD IDENTITY START HERE ---------------------------------------------------

resource "google_service_account" "workload_identity_user_sa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
}

data "google_client_config" "current" {}

resource "google_project_iam_member" "monitoring_role" {
  project = data.google_client_config.current.project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "apigateway_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/apigateway.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "cloudfunctions_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "discoveryengine_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/discoveryengine.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "secretmanager_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "serviceaccount_tokencreator_role" {
  project = data.google_client_config.current.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "storage_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "storage_objectadmin_role" {
  project = data.google_client_config.current.project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "aiplatform_admin_role" {
  project = data.google_client_config.current.project
  role    = "roles/aiplatform.admin"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "aiplatform_user_role" {
  project = data.google_client_config.current.project
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "pubsub_publisher_role" {
  project = data.google_client_config.current.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "pubsub_subscriber_role" {
  project = data.google_client_config.current.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "serviceusage_consumer_role" {
  project = data.google_client_config.current.project
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}

resource "google_project_iam_member" "workloadidentity_user_role" {
  project = data.google_client_config.current.project
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.workload_identity_user_sa.email}"
}


//GKE CLUSTER STARTS HERE ---------------------------------------------------------




resource "google_container_cluster" "disearch_cluster" {
  name                     = var.gke_cluster_name
  location                 = var.location
  network                  = "default"
  subnetwork               = google_compute_subnetwork.uscentral_disearch_vpc01_subnet1010016_gke.name
  remove_default_node_pool = true
  initial_node_count       = 1


  node_config {
    service_account = "terraform@${var.projectName}.iam.gserviceaccount.com"
  }
  release_channel {
    channel = "UNSPECIFIED"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-services-range"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.3.0.0/16"
    }
    cidr_blocks {
      cidr_block = "111.88.136.0/24"
    }
    cidr_blocks{
      cidr_block = "35.228.11.0/24"
    }
  }

  workload_identity_config {
    workload_pool = "${data.google_client_config.current.project}.svc.id.goog"  //workload identity
  }
  #monitoring_service = var.stackdriver_monitoring != "false" ? "monitoring.googleapis.com/kubernetes" : ""
  #logging_service = var.stackdriver_logging != "false" ? "logging.googleapis.com/kubernetes" : ""
  depends_on = [ google_project_service.enable_container, null_resource.global_delay]


}







//GKE CLUSTER ENDS HERE ------------------------------------------------------------








//CLUSTER NODE POOL STARTS HERE ------------------------------------------------

resource "google_container_node_pool" "general" {
  name    = "general"
  cluster = google_container_cluster.disearch_cluster.id
  node_count = 1
  version = var.gke_cluster_version

  autoscaling {
    # Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count.
    min_node_count = 1

    # Maximum number of nodes in the NodePool. Must be >= min_node_count.
    max_node_count = 1
  }

  management {
    auto_repair = true
    auto_upgrade = false
  }

  node_config {
    preemptible = false
    machine_type = var.gke_nodes_machine_type

    labels = {
        role = "general"
    }

    service_account = "terraform@${var.projectName}.iam.gserviceaccount.com"
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {    //workload identity
      mode = "GKE_METADATA"
    }
  }
  depends_on = [ google_container_cluster.disearch_cluster, null_resource.global_delay ]
}








//CLUSTER NODE POOL ENDS HERE ------------------------------------------------


resource "time_sleep" "wait_360_seconds" {
  depends_on = [ google_container_node_pool.general, null_resource.global_delay ]

  create_duration = "360s"
}


resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${var.gke_cluster_name}  --region=${var.location}"
    }
    depends_on = [ time_sleep.wait_360_seconds, null_resource.global_delay ]
}



resource "time_sleep" "wait_90_seconds" {
  depends_on = [ null_resource.kubectl, null_resource.global_delay ]

  create_duration = "90s"
}

//KUBECONFIG TEMPLATE STARTS HERE ------------------------------------------------





data "google_client_config" "default" { depends_on = [ time_sleep.wait_90_seconds, null_resource.global_delay ] }


# Create secrets in Google Secret Manager

resource "google_secret_manager_secret" "aretec_admin" {
  secret_id = "aretec_admin"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "aretec_admin_version" {
  secret      = google_secret_manager_secret.aretec_admin.id
  secret_data = var.aretec_admin
}

resource "google_secret_manager_secret" "DB_HOST" {
  secret_id = "DB_HOST"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "DB_PASSWORD" {
  secret_id = "DB_PASSWORD"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "DB_PASSWORD_version" {
  secret      = google_secret_manager_secret.DB_PASSWORD.id
  secret_data = var.db_password
}

resource "google_secret_manager_secret" "DB_USER" {
  secret_id = "DB_USER"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "DB_USER_version" {
  secret      = google_secret_manager_secret.DB_USER.id
  secret_data = var.db_username
}

resource "google_secret_manager_secret" "DOCUMENT_CHAT_URL" {
  secret_id = "DOCUMENT_CHAT_URL"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "GCP_BUCKET" {
  secret_id = "GCP_BUCKET"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "GCP_BUCKET_version" {
  secret      = google_secret_manager_secret.GCP_BUCKET.id
  secret_data = google_storage_bucket.disearch_storage_bucket.name
}

resource "google_secret_manager_secret" "image_summary_cloud_fn" {
  secret_id = "image_summary_cloud_fn"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "IS_VERTEXAI" {
  secret_id = "IS_VERTEXAI"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "IS_VERTEXAI_version" {
  secret      = google_secret_manager_secret.IS_VERTEXAI.id
  secret_data = "true"
}

resource "google_secret_manager_secret" "LOG_INDEX" {
  secret_id = "LOG_INDEX"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "LOG_INDEX_version" {
  secret      = google_secret_manager_secret.LOG_INDEX.id
  secret_data = var.projectName
}

resource "google_secret_manager_secret" "LOGS_URL" {
  secret_id = "LOGS_URL"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "LOGS_URL_version" {
  secret      = google_secret_manager_secret.LOGS_URL.id
  secret_data = var.LOGS_URL
}

resource "google_secret_manager_secret" "metadata_cloud_fn" {
  secret_id = "metadata_cloud_fn"
  replication {
    automatic = true
  }
}



resource "google_secret_manager_secret" "pdf_loadbalancer" {
  secret_id = "pdf_loadbalancer"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "project_id" {
  secret_id = "project_id"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "project_id_version" {
  secret      = google_secret_manager_secret.project_id.id
  secret_data = var.projectName
}

resource "google_secret_manager_secret" "redis-url" {
  secret_id = "redis-url"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "SCHEMA" {
  secret_id = "SCHEMA"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "SCHEMA_version" {
  secret      = google_secret_manager_secret.SCHEMA.id
  secret_data = var.SCHEMA
}

resource "google_secret_manager_secret" "service_key" {
  secret_id = "service_key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "service_key_version" {
  secret      = google_secret_manager_secret.service_key.id
  secret_data = file("./secret.json")
}

resource "google_secret_manager_secret" "status_cloud_fn" {
  secret_id = "status_cloud_fn"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "storage_bucket" {
  secret_id = "storage_bucket"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "storage_bucket_version" {
  secret      = google_secret_manager_secret.storage_bucket.id
  secret_data = var.storage_bucket_name
}

resource "google_secret_manager_secret" "vertexai_citation" {
  secret_id = "vertexai_citation"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "vertexai_followup" {
  secret_id = "vertexai_followup"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "vertexai_python_url" {
  secret_id = "vertexai_python_url"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "vertexai-referer" {
  secret_id = "vertexai-referer"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "vertexai-summary" {
  secret_id = "vertexai-summary"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "APP_VERSION" {
  secret_id = "APP_VERSION"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "APP_VERSION_version" {
  secret      = google_secret_manager_secret.APP_VERSION.id
  secret_data = var.APP_VERSION
}

resource "google_secret_manager_secret" "OPENAI_API_KEY" {
  secret_id = "OPENAI_API_KEY"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "OPENAI_API_KEY_version" {
  secret      = google_secret_manager_secret.OPENAI_API_KEY.id
  secret_data = var.OPENAI_API_KEY
}



