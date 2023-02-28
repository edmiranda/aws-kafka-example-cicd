variable "name" {
  type    = string
  default = "example"
}

variable "vpc_id" {
  type = string
}

variable "private_subnets_cidr_blocks" {
  type = list(any)
}

variable "private_route_table_ids" {
  type = list(any)
}

variable "private_subnets" {
  type = list(any)
}

variable "tags" {
  type    = map(string)
  default = {}
}