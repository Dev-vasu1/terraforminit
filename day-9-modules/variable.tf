variable "name" {
    type = string
  
}
variable "ami_id" {
    type = string
    default = null
}
variable "instance_type" {
    type = string
    default = null
  
}
variable "subnet_id" {
    type = string
    default = null  
}
