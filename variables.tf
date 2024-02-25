variable "hcloud_token" {
}
variable "path_pub_key" {
}
variable "path_private_key" {
}
variable "server_name" {
  default = "server"
}
variable "server_type" {
  default = "cx11"
}
variable "location" {
  default = "fsn1"
}
variable "number_servers" {
  description = "describe your variable"
  default     = "1"
}
