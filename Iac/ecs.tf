resource "aws_ecs_cluster" "medusa_cluster" {
    name = "Medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa_task_definition" {
  family                   = "medusa-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([{
    name      = "medusa-backend"
    image     = "${aws_ecr_repository.medusa_repository.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 9000
      hostPort      = 9000
    }]
  }])
}

resource "aws_ecs_service" "medusa_backend_service" {
  name            = "medusa-backend-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command = true

  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.medusa_sg.id]
    subnets         = aws_subnet.public_subnet[*].id
  }

}