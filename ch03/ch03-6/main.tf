variable "string" {
  type        = string
  description = "var String"
  default     = "myString"
}
variable "number" {
  type    = number
  default = 123

}

variable "boolean" {
  default = true
}

variable "list" {
  default = [
    "google",
    "vmware",
    "amazon",
    "microsoft"
  ]
}
output "list_index_0" {
  value = var.list.0
}
output "list_all" {
  value = [
    for name in var.list :
    upper(name)
  ]
}

variable "map" {
  default = {
    aws   = "amazon",
    azure = "microsoft",
    gcp   = "google"
  }
}

variable "set" {
  type = set(string)
  default = [
    "google",
    "vmware",
    "amazon",
  "microsoft"]
}

variable "object" {
  type = object({
    name = string, age = number
  })
  default = {
    name = "abc"
    age  = 12
  }
}

variable "tuple" {
  type    = tuple([string, number, bool])
  default = ["abc", 123, true]
}

variable "ingress_rules" {
  type = list(object({
    port        = number,
    description = optional(string),
    protocol    = optional(string, "tcp"),
  }))
  default = [
    { port = 80, description = "web" },
  { port = 53, description = "udp" }]
}

/*variable "region" {
 8 default = "ap-northeast-2"
}

resource "aws_instance" "aws04-web" {
  region = var.region
  key_name = aws04-key.pem
  vpc_security_group_ids = data.aws_security_group.sg04.id
}*/
