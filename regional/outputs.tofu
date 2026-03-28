# Output Values
# https://opentofu.org/docs/language/values/outputs

output "container_cluster_ca_certificate" {
  description = "Base64 encoded public certificate that is the root of trust for the cluster"
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
}

output "container_cluster_endpoint" {
  description = "The connection endpoint for the cluster"
  value       = google_container_cluster.this.endpoint
}

output "container_cluster_id" {
  description = "The unique identifier for the cluster"
  value       = google_container_cluster.this.id
}

output "container_cluster_name" {
  description = "The name of the cluster, unique within the project and location"
  value       = google_container_cluster.this.name
}

output "kms_crypto_key_cluster_boot_disk_encryption_name" {
  description = "The name of the Google Cloud KMS crypto key used to encrypt the boot disk"
  value       = google_kms_crypto_key.this["cluster-boot-disk-encryption"].name
}

output "kms_crypto_key_cluster_database_encryption_name" {
  description = "The name of the Google Cloud KMS crypto key used to encrypt the secrets"
  value       = google_kms_crypto_key.this["cluster-database-encryption"].name
}

output "kms_key_ring_cluster_encryption_name" {
  description = "The name of the Google Cloud KMS key ring"
  value       = google_kms_key_ring.cluster_encryption.name
}

output "service_account_default_node_email" {
  description = "The email address of the Kubernetes minimum privilege service account for the cluster"
  value       = google_service_account.default_node.email
}
