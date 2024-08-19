variable "projectName" {
  description = "Name of the Project"
  type        = string
  default     = ""
}

variable "region" {
  description = "Name of the Region"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "Name of the Location"
  type        = string
  default     = "us-central1-c"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "uscentral-vpc01-100008"
}

variable "vpc_connector" {
  description = "Name of the VPC"
  type        = string
  default     = "disearch-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "uscentral-disearch-vpc01-subnet1000024"
}

variable "gke_subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "uscentral-disearch-vpc01-subnet1010016-gke"
}

variable "db-instance-name" {
  description = "Prefix for database instance name"
  type        = string
  default     = "disearch-database"
}

variable "db_instance_name_prefix" {
  description = "Prefix for database instance name"
  type        = string
  default     = "disearch-db"
}

variable "db_instance_disk_size" {
  description = "Disk Size for Database Instance"
  type        = string
  default     = "20"
}

variable "db_version" {
  description = "Prefix for database instance name"
  type        = string
  default     = "POSTGRES_14"
}

variable "db_username" {
  description = "Name of the database user"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password of the database user"
  type        = string
  default     = ""
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run Service"
  type        = string
  default     = "my-cloud-run-service"
}


variable "gke_cluster_name" {
  description = "Name of the Cluster Name"
  type        = string
  default     = "disearch-cluster"
}

variable "gke_cluster_version" {
  description = "GKE Cluster Version for Master and Workers"
  type        = string
  default     = "1.27.3-gke.100"
}

variable "gke_nodes_machine_type" {
  description = "Instance Type for GKE Worker Nodes"
  type        = string
  default     = "e2-highmem-4"
}

variable "gke_minimum_nodes" {
  description = "Minimum Worker Nodes Required for GKE Cluster"
  type        = number
  default     = 1
}

variable "gke_maximum_nodes" {
  description = "Maximum Worker Nodes Required for GKE Cluster"
  type        = number
  default     = 1
}

variable "storage_bucket_name" {
  description = "Name for the Storage Bucket"
  type        = string
  default     = "disearch-storage-bucket"
}

variable "STRIPE_SECRET_KEY" {
  description = "STRIPE SECRET KEY value"
  type        = string
  default     = ""
}

variable "aretec_admin" {
  description = "aretec admin password"
  type        = string
  default     = "secret123"
}

variable "LOGS_URL" {
  description = "Log url"
  type        = string
  default     = ""
}

variable "OPENAI_KEY" {
  description = "KEY"
  type        = string
  default     = ""
}

variable "SCHEMA" {
  description = "KEY"
  type        = string
  default     = "disearch"
}

variable "OPENAI_API_KEY" {
  description = "KEY"
  type        = string
  default     = ""
}

variable "APP_VERSION" {
  description = "value"
  type        = string
  default     = "ST"
}






