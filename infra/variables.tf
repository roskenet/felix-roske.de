variable "domain_name" {
  description = "Die Hauptdomain für deine Website (z. B. www.felix-roske.de)"
  type        = string
}

variable "root_domain" {
  description = "Die Root-Domain (z. B. felix-roske.de)"
  type        = string
}

variable "region" {
  description = "Die AWS region"
  type        = string
}
