# resource "aws_codedeploy_app" "this" {
#   name             = var.portfolio_app_1_tag
#   compute_platform = "Server"
# }

# resource "aws_codedeploy_deployment_group" "this" {
#   app_name              = aws_codedeploy_app.this.name
#   deployment_group_name = var.portfolio_app_1_tag
#   service_role_arn      = aws_iam_role.this.arn

#   ec2_tag_set {
#     ec2_tag_filter {
#       type  = "KEY_AND_VALUE"
#       key   = "Name"
#       value = var.portfolio_app_1_tag
#     }
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }
