output "vpc_id" {
  value = module.vpc.vpc_id
}

output "elb_dns_name" {
  value = "${aws_elb.edu-12-elb.dns_name}"
}