output "writer_fqdn" {
  description = "Domain name for writer endpoint"
  value       = aws_route53_record.writer.fqdn
}

output "reader_fqdn" {
  description = "Domain name for reader endpoint"
  value       = aws_route53_record.reader.fqdn
}

output "sg" {
  description = "Security group for database"
  value       = aws_security_group.sg.id
}

output "sg_intra" {
  description = "DEPRECATED: Security group allowed for access"
  value       = aws_security_group.intra.id
}

output "cluster_arn" {
  description = "Aurora RDS cluster ARN"
  value       = aws_rds_cluster.cluster.arn
}

output "cluster_port" {
  description = "Database port"
  value       = aws_rds_cluster.cluster.port
}
