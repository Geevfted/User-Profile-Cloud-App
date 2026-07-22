output "bucket_name" {
  description = "Name of the s3 bucket"
  value       = aws_s3_bucket.profile_images.bucket
}

output "ec2_public_ip" {
  description = "Your IP is"
  value = aws_instance.profile_app_server.public_ip
}