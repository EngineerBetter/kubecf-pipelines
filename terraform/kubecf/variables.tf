variable "dns_zone_name" {
  type        = string
  description = "Name of Cloud DNS zone created in project"
}

variable "region" {
  type        = string
  description = "Google Cloud region in which to deploy all resources"
}

variable "project_id" {
  type = string
}
