# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "main_ec2" {
  ami           = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2023 (서울 리전)
  instance_type = "t2.micro"
  tags = {
    Name = "goorm-test-ec2"
  }
}

resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "ec2-monitor-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.main_ec2.id}" ]
          ],
          period = 300,
          stat = "Average",
          region = "ap-northeast-2",
          title = "EC2 CPU Utilization"
        }
      }
    ]
  })
}
