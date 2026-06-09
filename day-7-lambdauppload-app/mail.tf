resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"
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
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# The AWSLambdaBasicExecutionRole policy provides the necessary permissions for the Lambda function to write logs to CloudWatch, which is essential for monitoring and debugging your Lambda function. By attaching this policy to the IAM role, you ensure that your Lambda function has the required permissions to execute successfully and log its output.
resource "aws_lambda_function" "my_lambda" {
    function_name = "MyLambdaFunction"
    role          = aws_iam_role.lambda_role.arn
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    filename      = "lambda_function.zip"

#The source_code_hash argument is crucial for ensuring that Terraform detects changes to your Lambda function's code. When you upload a new ZIP file with updated code, the hash will change, prompting Terraform to update the Lambda function accordingly. Without this, Terraform might not recognize that the code has changed, and your Lambda function would not be updated as expected.
source_code_hash = filebase64sha256("lambda_function.zip")
}