locals {
  tags = merge(
    var.default_tags,
    var.env_tags,
    {
      "environment" = var.environment
      "component"   = var.component
    },
  )

}
