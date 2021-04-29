# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
source env.sh

echo "Building zip file"
zip -rq application.zip application/

echo "Creating IAM role"
ROLE_ARN=$(aws iam create-role \
  --role-name Cloud9-recommendations-api-lambda-role \
  --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }' \
  --query 'Role.Arn' \
  --output text)

echo "Adding policy to IAM role"
POLICY=$(aws iam put-role-policy \
  --role-name Cloud9-recommendations-api-lambda-role \
  --policy-name lambda-policy \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Resource": "*",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cognito-idp:AdminConfirmSignUp",
          "cognito-idp:AdminInitiateAuth",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface"
        ],
        "Effect": "Allow"
      }
    ]
  }')

echo "Sleeping for IAM role propagation"
sleep 10
echo "Creating Lambda function"
FUNCTION_ARN=$(aws lambda create-function \
  --function-name recommendations-api \
  --runtime nodejs10.x \
  --role ${ROLE_ARN} \
  --handler application/handler.handler \
  --timeout 12 \
  --memory 1024 \
  --publish \
  --environment '{
    "Variables": {
      "USER_POOL_ID": "'${USER_POOL_ID}'",
      "COGNITO_CLIENT_ID": "'${COGNITO_CLIENT_ID}'",
      "NEPTUNE_ENDPOINT": "'${NEPTUNE_ENDPOINT}'"
    }
  }' \
  --vpc-config '{
    "SubnetIds": ["'${SUBNET_ID}'"],
    "SecurityGroupIds": ["'${SECURITY_GROUP_ID}'"]
  }' \
  --zip-file fileb://application.zip \
  --query 'FunctionArn' \
  --output text)

echo "Lambda function created with ARN ${FUNCTION_ARN}"
echo "export FUNCTION_ARN=${FUNCTION_ARN}" >> env.sh
