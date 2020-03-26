resource "aws_route53_zone" "goodcoin_org" {
  name    = "good-coin.org"
  comment = "Managed by Terraform - do not edit manually"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.goodcoin_org.zone_id}"
}
