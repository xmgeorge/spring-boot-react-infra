locals {
  tags = merge(
    var.default_tags,
    var.env_tags,
    {
      "environment" = var.environment
      "component"   = var.component
    },
  )
  cluster_name = "${var.project}-${var.environment}-eks"
  vpc_name     = "${var.project}-${var.environment}"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)

}