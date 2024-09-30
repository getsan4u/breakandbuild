variable "environment" {
  description = "environment name :  SandBox, Dev, Test, QA, Staging, and Prod"
  default     = "Dev"
}

variable "service" {
  description = "service name : Nimbus-Asset , Nimbus-Trade, Nimbus-Performance "
  default     = "Nimbus-Asset"
}


variable "trusted_ip_ranges" {
  description = "List of trusted IP ranges allowed to access ECS service"
  type        = list(string)
  default     = ["203.0.113.0/24", "198.51.100.0/24"] 
  # Replace with your trusted IPs like company VPN
}

variable "regions"{
  description = "AWS region to deploy the service"
  default     = "eu-west-2"
}