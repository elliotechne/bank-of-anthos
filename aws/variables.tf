variable "region" {
    description = "The region where to provision resources"
    type = string
}

variable "zerossl_eab_key_id" {
    description = "ZeroSSL eab key id"
    type = string
}

variable "zerossl_eab_hmac_key" {
    description = "ZeroSSL eab hmac key"
    type = string
}
