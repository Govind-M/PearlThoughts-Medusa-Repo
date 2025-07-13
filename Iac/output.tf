
output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "ID of the default VPC"
}


output "ecs_cluster_id" {
  value       = aws_ecs_cluster.medusa_cluster.id
  description = "ID of the ECS cluster"
}


output "ecs_service_id" {
  value       = aws_ecs_service.medusa_backend_service.id
  description = "ID of the ECS service"
}


output "ecr_repository_url" {
  value       = aws_ecr_repository.medusa_repository.repository_url
  description = "URL of the ECR repository"
}


