resource "aws_s3_bucket" "name" {
    bucket = "vasudev-lambda-upload-bucket"
tags = {
        Name = "My S3 Bucket"
    }
}

# Create an IAM role for Lambda
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

resource "aws_lambda_function" "my_lambda" {
  function_name = "MyLambdaFunction"

  role    = aws_iam_role.lambda_role.arn
  runtime = "nodejs20.x"
  handler = "index.handler"

  s3_bucket = "my-existing-bucket"
  s3_key    = "lambda/my-function.zip"
}