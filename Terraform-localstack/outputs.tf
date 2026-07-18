output "bucket_name" {
  description = "Name of the s3 bucket"
  value       = aws_s3_bucket.profile_images.bucket
}
