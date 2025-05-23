variable "django_ports" {
  description = "External ports for Django containers"
  type        = list(number)
  default     = [8000, 8001]
}