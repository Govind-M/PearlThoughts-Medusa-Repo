resource "aws_ecr_repository" "medusa_repository" {
    name = "medusa-backend-repo"
    image_scanning_configuration {
    scan_on_push = true
    }
    tags = {
    name        = "medusa-backendrepo"
    }
}