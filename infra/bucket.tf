resource "aws_cloudfront_origin_access_identity" "cfoai" {
  comment = "oai for bucket access"
}

resource "aws_s3_bucket" "this" {
  bucket = "haryel-ifsp-angular"
  tags = {
    Name        = "hca-ifsp-angular-webpage"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["www.haryelifsp.tk"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cfoai.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.this.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cfoai.iam_arn]
    }
  }
}
