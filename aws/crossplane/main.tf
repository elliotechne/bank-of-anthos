output "arn" {
  value       = aws_s3_bucket.wayofthesys.arn
}

resource "aws_s3_bucket" "wayofthesys" {
  bucket = "wayofthesys-crossplane-remote"

  tags = {
    Name        = "WayOfTheSys Crossplane"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "wayofthesys" {
   bucket = aws_s3_bucket.wayofthesys.id
   acl    = "private"
}
