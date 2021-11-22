# resource "aws_lb_target_group" "edu-12-lb-tg" {
#   name     = "edu-12-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     path                = var.lb_check_path
#     interval            = 30
#     port                = 80
#     matcher             = "200"
#   }

#   tags = {
#     Name = "edu-12-lb-tg"
#   }
# }

# resource "aws_lb_target_group_attachment" "edu-12-lb-tg-public" {
#   target_group_arn = aws_lb_target_group.edu-12-lb-tg.arn
#   target_id        = aws_instance.edu-12-public-instace.id
#   port             = 80
# }

# resource "aws_autoscaling_attachment" "edu-12-lb-tg-public" {
#   autoscaling_group_name = aws_autoscaling_group.edu-12-asg.id
#   alb_target_group_arn   = aws_lb_target_group.edu-12-lb-tg.arn
# }


# resource "aws_lb_listener" "edu-12-lb-listener" {
#   load_balancer_arn = aws_lb.edu-12-lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.edu-12-lb-tg.arn
#     type             = "forward"
#   }
# }

# resource "aws_lb" "edu-12-lb" {
#   name               = "edu-12-lb"
#   load_balancer_type = "application"
#   subnets            = flatten(module.vpc.public_subnet_ids)
#   security_groups    = [aws_security_group.edu-12-web-sg-public.id]

#   tags = {
#     Name = "edu-12-lb"
#   }
# }

## Security Group for ELB
resource "aws_security_group" "edu-12-elb-sg" {
  name = "terraform-example-elb"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "edu-12-lb"
  }
  vpc_id = module.vpc.vpc_id
}

resource "aws_elb" "edu-12-elb" {
  name            = "edu-12-elb"
  security_groups = [aws_security_group.edu-12-elb-sg.id]
  subnets         = flatten(module.vpc.public_subnet_ids)
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80${var.lb_check_path}"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
  depends_on = [
    aws_security_group.edu-12-elb-sg
  ]
}

