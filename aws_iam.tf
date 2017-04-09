###############################################
#IAM Settings
###############################################
resource "aws_iam_role" "get-sample" {
    name = "get-sample"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dynamodb.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "2"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "get-sample" {
    name = "get-sample"
    role = "${aws_iam_role.get-sample.id}"

    policy = "${file("policy/get-sample.json")}"
}

resource "aws_iam_role" "post-sample" {
    name = "post-sample"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dynamodb.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "2"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "post-sample" {
    name = "post-sample"
    role = "${aws_iam_role.post-sample.id}"

    policy = "${file("policy/post-sample.json")}"
}
