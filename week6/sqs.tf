resource "aws_sqs_queue" "edu-12-sqs" {
  name = var.sqs_name
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.edu-12-sqs.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Action": "SQS:*",
      "Resource": "${aws_sqs_queue.edu-12-sqs.arn}"
    }
  ]
}
POLICY
}