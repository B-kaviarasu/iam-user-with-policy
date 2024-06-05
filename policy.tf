resource "aws_iam_user_policy" "this" {
  count = var.create_policy && var.policy_statement != "" ? 1 : 0

  name   = var.policy_name
  user   = aws_iam_user.this[0].name
  policy = var.policy_statement
}

resource "aws_iam_user_policy_attachment" "this" {
  count = var.attach_managed_policy && var.managed_policy_arns != [] ? length(var.managed_policy_arns) : 0

  user       = aws_iam_user.this[0].name
  policy_arn = element(var.managed_policy_arns, count.index)
}
