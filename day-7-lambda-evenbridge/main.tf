resource "aws_lambda_function" "example" {
    function_name = "example_lambda_function"
    role          = aws_iam_role.lambda_exec.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.8"
    
    filename      = "lambda_function.zip"
    source_code_hash = filebase64sha256("lambda_function.zip")
}
# The source_code_hash argument is crucial for ensuring that Terraform detects changes to your Lambda function's code. When you upload a new ZIP file with updated code, the hash will change, prompting Terraform to update the Lambda function accordingly. Without this, Terraform might not recognize that the code has changed, and your Lambda function would not be updated as expected.
resource "aws_iam_role" "lambda_exec" {
    name = "lambda_executionm"
    assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}
# The aws_iam_role_policy_attachment resource is used to attach the AWSLambdaBasicExecutionRole policy to the IAM role created for the Lambda function. This policy provides the necessary permissions for the Lambda function to write logs to CloudWatch, which is essential for monitoring and debugging your Lambda function. By attaching this policy to the IAM role, you ensure that your Lambda function has the required permissions to execute successfully and log its output.
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# The AWSLambdaBasicExecutionRole policy provides the necessary permissions for the Lambda function to write logs to CloudWatch, which is essential for monitoring and debugging your Lambda function. By attaching this policy to the IAM role, you ensure that your Lambda function has the required permissions to execute successfully and log its output.
resource "aws_cloudwatch_event_rule" "example" {
    name                = "example_event_rule"
    schedule_expression = "rate(5 minutes)"
}
# The aws_cloudwatch_event_target resource specifies the target for the CloudWatch Event rule, which in this case is the Lambda function. The aws_lambda_permission resource grants permission for the CloudWatch Events service to invoke the Lambda function when the rule is triggered. This setup allows your Lambda function to be executed automatically based on the defined schedule in the CloudWatch Event rule.
resource "aws_cloudwatch_event_target" "example" {
    rule      = aws_cloudwatch_event_rule.example.name
    target_id = "example_lambda_target"
    arn       = aws_lambda_function.example.arn
}
# The aws_lambda_permission resource grants permission for the CloudWatch Events service to invoke the Lambda function when the rule is triggered. This setup allows your Lambda function to be executed automatically based on the defined schedule in the CloudWatch Event rule.
resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id  = "AllowExecutionFromEventBridge"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.example.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.example.arn
}