resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole2"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_ecs_cluster" "cluster" {
  name = "fastapi-cluster"
}
resource "aws_ecs_task_definition" "task" {
  family                   = "fastapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "fastapi"
      image = var.container_image
      portMappings = [{
        containerPort = 8000
      }]
    }
  ])
}
resource "aws_ecs_service" "service" {
  name            = "fastapi-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "fastapi"
    container_port   = 8000
  }
}

