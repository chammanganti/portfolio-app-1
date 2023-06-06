variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "app_tag" {
  description = "Portfolio App 1 tag"
  type        = string
  default     = "portfolio_app_1"
}

variable "record_name" {
  description = "Portfolio App 1 DNS record"
  type        = string
  default     = "portfolio-app-1.chammanganti.dev"
}
