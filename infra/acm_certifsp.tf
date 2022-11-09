resource "aws_acm_certificate" "cert_haryelifsp" {
  domain_name       = "www.haryelifsp.tk"
  validation_method = "DNS"
  provider          = aws.useast1
}

resource "aws_route53_record" "validacao_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert_haryelifsp.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.haryelifsp_zone.zone_id
}

resource "aws_acm_certificate_validation" "acm_validacao" {
  provider                = aws.useast1
  certificate_arn         = aws_acm_certificate.cert_haryelifsp.arn
  validation_record_fqdns = [for record in aws_route53_record.validacao_cert_record : record.fqdn]
}
