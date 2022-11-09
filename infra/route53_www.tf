resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.haryelifsp_zone.zone_id
  name    = "www.haryelifsp.tk"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}