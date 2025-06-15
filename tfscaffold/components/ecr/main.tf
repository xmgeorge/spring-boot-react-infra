resource "aws_ecr_repository" "foo" {
  name                 = "${var.project}-${var.environment}-ecr-image"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}