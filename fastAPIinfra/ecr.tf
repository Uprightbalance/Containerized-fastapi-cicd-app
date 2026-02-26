resource "aws_ecr_repository" "fastapi" {
  name = "fastapi-cicd-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true
  }
}

