variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "Google Cloud region in which to deploy all resources"
}

variable "node_counts_per_zone" {
  type = object({
    min = number
    max = number
  })
  default = { min = 1, max = 1 }
}
