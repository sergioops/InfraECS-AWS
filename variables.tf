variable "service_name" {
  type = list(any)
  default = [
    "frontend",
    "backend",
  ]
}

variable "service_port" {
  type = map(string)
  default = {
    frontend    = "3000"
    backend   = "3000"
  }
}

variable "db_cluster" {
  type = list(any)
  default = [
    "backend",
  ]
}

variable "db_instance" {
  type = map(string)
  default = {
    backend    = "db.r6g.2xlarge"
  }
}

variable "memcached_cluster" {
  type = list(any)
  default = [
    "frontend",
  ]
}

variable "memcached_instance" {
  type = map(string)
  default = {
    frontend    = "cache.t3.small"
  }
}

variable "domain" {
  type = map(object({
    corp = list(string)
  }))
  default = {
    homologacao = {
      corp = [""]
    }
    producao = {
      corp = ["sergioops.com"]
    }
  }
}

variable "subdomain" {
  type = map(object({
    backend    = string
  }))
  default = {
    homologacao = {
      backend = ""
    }
    producao = {
      backend = "api"
    }
  }
}

variable "account_id" {
  type = map(string)
  default = {
    homologacao = ""
    producao    = "11111111"
  }
}

variable "customer_name" {
  default = "sergiops"
}

variable "rds_username" {
  default = ""
}

variable "rabbit_username" {
  default = ""
}

variable "rabbit_password" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_blocks" {
  type = map(string)
  default = {
    homologacao = ""
    producao    = "10.10.0.0/16"
  }
}

variable "subnet_cidr_blocks" {
  type = map(object({
    public  = list(string),
    private = list(string)
  }))
  default = {
    homologacao = {
      public  = ["", "", ""],
      private = ["", "", ""]
    }
    producao = {
      public  = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"],
      private = ["10.10.128.0/20", "10.10.144.0/20", "10.10.160.0/20"]
    }
  }
}

variable "certificate_arn" {
  type = map(object({
    corp = list(string)
  }))
  default = {
    homologacao = {
      corp = [""]
    }
    producao = {
      corp = [""]
    }
  }
}



variable "route_table_cidr_blocks" {
  type = map(object({
    public  = list(string),
    private = list(string)
  }))
  default = {
    hml = {
      public  = [""],
      private = [""]
    }
    prod = {
      public  = [""],
      private = [""]
    }
  }
}