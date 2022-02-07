# Number Variables
variable "any1" {
    type    = any
    default = "x"
}
variable "any2" {
    type    = any
    default = 33
}
variable "any3" {
    type    = any
    default = true
}

# Number Variables
variable "num1" {
    type    = number
    default = 2
}
variable "num2" {
    type    = number
    default = 3
}

# String Variables
variable "str1" {
    type    = string
    default = "Lorem ipsum dolor sit amet, consectetur adipisici elit"
}
variable "str2" {
    type    = string
    default = "xyz"
}
variable "str3" {
    type    = string
    default = "tet"
}

# Bool Variables
variable "bool1" {
    type    = bool
    default = true
}
variable "bool2" {
    type    = bool
    default = false
}


# List Variables
variable "liststr1" {
    type    = list(string)
    default = ["a", "b", "b", "c", "d", "e", "e"]
}
variable "liststr2" {
    type    = list(string)
    default = ["westeurope", "eastus", "japaneast"]
}
variable "listnum1" {
    type    = list(number)
    default = [1, 2, 3, 5, 8, 13, 21, 34, 55]
}

# Set Variables => duplicates automatically removed during load
variable "setstr1" {
    type    = set(string)
    default = ["a", "b", "b", "c", "d", "e", "e"]
}
variable "setstr2" {
    type    = set(string)
    default = ["westeurope", "eastus", "japaneast"]
}
variable "setnum1" {
    type    = set(number)
    default = [1, 2, 3, 5, 5, 8, 8, 13, 21, 34, 55]
}

# Tuple Variables
variable "tuple1" {
    type    = set(string)
    default = ["a", 1, "b", 2, "b", 2, "c", 3, "d", 4, "e", 5, "e", 5]
}
variable "tuple2" {
    type    = set(string)
    default = ["westeurope", true, "eastus", true, 33, "japaneast"]
}

# Map Variables
variable "mapProtocolVsPort" {
    type    = map(string)
    default = {
        HTTP:  80,
        HTTPS: 443,
        SQL:   1433,
        RDP:   3389
    }
}

# Object Variables
variable "objectSingleKeyVaultAccessPolicy" {
    type    = object({
      object_id         = string,
      secret_permission = string,
      key_permission    = string                
    })
    default = {
        object_id         = "123",
        secret_permission = "get"
        key_permission    = "list"
    }
}

# Complex Variables
variable "defaultKeyVaultAccessPolicies" {
  type = set(
    object({
      object_id          = string,
      secret_permissions = set(string),
      key_permissions    = set(string)
    })
  )
  default = [
        {
          object_id          = "123",
          secret_permissions = ["get", "list"],
          key_permissions    = null      
        },
        {
          object_id          = "456",
          secret_permissions = ["create", "get", "list"],
          key_permissions    = ["get", "list"]      
        }        
  ]
}

