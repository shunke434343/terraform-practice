# バケットを作成
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-pragmatic-shunka"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

# ポリシーを作成（バケットへのアクセス制御）
# ALBのようなサービスからS3に書き込みを行う場合に必要
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

# ポリシードキュメントを取得
data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_log.arn}", "${aws_s3_bucket.alb_log.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"] # 書き込みを行うアカウントID リージョンごとに異なる これは東京のやつ
    }
  }
}
