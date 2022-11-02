variable "region" {
    description = "The region where to provision resources"
    type = string
}
variable "bucket_name" {
    description = "The name of S3 bucket"
    default = "wayofthesys-test-bucket"
    type = string
}
