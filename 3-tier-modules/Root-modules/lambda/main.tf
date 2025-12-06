resource "aws_lambda_function" "log_archiver" {
  function_name = "cloudwatch_log_archiver"
  role          = aws_iam_role.lambda_role.arn
  handler       = "log_archive.lambda_handler"
  runtime       = "python3.12"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  timeout = 30
}

resource "aws_cloudwatch_log_subscription_filter" "archive_filter" {
  name            = "send_logs_to_lambda"
  log_group_name  = "/aws/lambda/your-backend-log-group"
  filter_pattern  = ""
  destination_arn = aws_lambda_function.log_archiver.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCWLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_archiver.function_name
  principal     = "logs.amazonaws.com"
}
