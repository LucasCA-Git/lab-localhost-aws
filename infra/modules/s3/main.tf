resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-data-lake-raw"

  force_destroy = true
}

resource "aws_s3_bucket" "silver" {
  bucket = "${var.project_name}-data-lake-silver"

  force_destroy = true
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.project_name}-athena-results"

  force_destroy = true
}
