  provider "aws" {
    region = "ap-northeast-2"
  }

  # ---------- TLS 개인 키 생성 --------
  /*
  이 리소스는 개인 키를 생성하며, 이와 함께 공개 키도 생성
  공개 키는 tls_private_key.project_make_key.public_key_openssh로 접근 가능
  개인 키는 tls_private_key.project_make_key.private_key_pem로 접근 가능
  */
  resource "tls_private_key" "project_make_key" { # 공개 및 개인 키 생성
    algorithm = "RSA"
    rsa_bits  = 4096
  }

  # AWS 키 페어 생성
  /*
  AWS에서는 공개 키를 저장하여 EC2 인스턴스에 배포
  인스턴스는 이 공개 키를 사용하여 SSH 접근을 허용
  EC2 인스턴스는 개인 키를 저장하지 않기 때문에 local에서 가지고 있어야 함
  */
  resource "aws_key_pair" "project_make_keypair" { # 키 페어 리소스 이름
    key_name   = "project_key" # 키 이름
    public_key = tls_private_key.project_make_key.public_key_openssh # project_make_key 리소스에서 생성된 공개 키를 사용
  }

  # local 파일에 개인 키 저장
  /*
  개인 키를 저장해야 SSH 접근 시 사용할 수 있음
  */
  resource "local_file" "project_downloads_key" { # 개인 키 리소스 이름
    filename = "project_key.pem" # 파일 이름 설정
    content  = tls_private_key.project_make_key.private_key_pem # 리소스에서 생성된 개인 키를 저장
  }

  # --------- 보안 그룹 설정 --------- 
  /*
  AWS 에서 인스턴스와 같은 리소스의 네트워크 트래픽을 제어하는 방화벽 역할
  inbound, outbound 트래픽 규칙을 정의
  */
  resource "aws_security_group" "project_security" { # 보안 그룹 리소스 이름
    name_prefix = "project_security_group" # 보안 그룹 리스트에 등록될 이름
    vpc_id      = aws_vpc.project_vpc.id # 보안 그룹이 연결될 VPC, EC2 에 적용하기 전 먼저 EC2 가 사용할 VPC 와 연결해줘야 함
  }

  # inbound - SSH
  resource "aws_security_group_rule" "ingress_ssh" { # 보안 규칙 리소스 이름
    type             = "ingress" # 규칙 타입 
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id 
  }

  # inbound - HTTPS
  resource "aws_security_group_rule" "ingress_https" {
    type             = "ingress"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # inbound - HTTP
  resource "aws_security_group_rule" "ingress_http" {
    type             = "ingress"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # inbound - 스프링부트_첫번째
  resource "aws_security_group_rule" "ingress_spring_boot_first" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # inbound - 스프링부트_두번째
  resource "aws_security_group_rule" "ingress_spring_boot_second" {
    type             = "ingress"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # inbound - MYSQL
  resource "aws_security_group_rule" "ingress_mysql" {
    type             = "ingress"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # inbound - Grafana
  resource "aws_security_group_rule" "ingress_grafana" {
    type             = "ingress"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }


# inbound - Prometheus
  resource "aws_security_group_rule" "ingress_prometheus" {
    type             = "ingress"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # outbound - 모든 트래픽 허용
  resource "aws_security_group_rule" "egress_all" {
    type             = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.project_security.id
  }

  # VPC 정의
  /*
  AWS VPC 리소스를 정의
  */
  resource "aws_vpc" "project_vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
      Name = "project-vpc"
    }
  }

  # subnet 정의 (가용 영역 지정)
  resource "aws_subnet" "project_subnet" {
    cidr_block = "10.0.1.0/24" # VPC 에서의 subnet이 사용할 IP 범위
    vpc_id     = aws_vpc.project_vpc.id # subnet이 속할 vpc 
    availability_zone = "ap-northeast-2a" # 또는 다른 지원되는 가용 영역
    
    tags = {
      Name = "project-subnet"
    }
  }

  # EC2 인스턴스 정의
  resource "aws_instance" "project_instance" {
    ami                      = "ami-05d2438ca66594916" # 운영체제 이미지 - ubuntu
    instance_type            = "t2.micro" # EC2 인스턴스 타입
    key_name                 = aws_key_pair.project_make_keypair.key_name # EC2 SSH 접근 시 사용할 공개 키 저장
    vpc_security_group_ids   = [aws_security_group.project_security.id] # 보안 그룹 설정
    subnet_id                = aws_subnet.project_subnet.id # subnet ID 추가
    associate_public_ip_address = true # public IP 주소 할당 여부

    root_block_device {
        volume_size = 30 # 볼륨 크기 설정 (GiB)
        volume_type = "gp3" # 일반적인 범용 SSD (gp2) 타입
    }

    # swap 메모리 설정을 위한 user_data 스크립트
    user_data = <<EOF
      #!/bin/bash
      # Create a swap file of 20GB
      sudo fallocate -l 10G /swapfile
      sudo chmod 600 /swapfile
      sudo mkswap /swapfile
      sudo swapon /swapfile

      # Make swap file permanent by adding it to /etc/fstab
      echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    EOF

    tags = {
      Name = "project-instance"
    }
  }

  # --------- 인터넷 gateway, routing table 생성 ---------
  # 인터넷 gateway 
  resource "aws_internet_gateway" "project_igw" {
      vpc_id = aws_vpc.project_vpc.id

      tags = {
          Name = "project-igw"
      }
  }
  # routing table
  resource "aws_route_table" "project_rt" {
      vpc_id = aws_vpc.project_vpc.id

      route {
          cidr_block = "0.0.0.0/0" # 모든 IP 주소에 대해
          gateway_id = aws_internet_gateway.project_igw.id # 인터넷 gateway로 routing
      }

      tags = {
          Name = "project-rt"
      }
  }
  # subnet에 routing table 적용
  resource "aws_route_table_association" "project_rta" {
      subnet_id = aws_subnet.project_subnet.id
      route_table_id = aws_route_table.project_rt.id
  }

  # 같은 Subnet 통신 간 내부 통신 보안 그룹 열기
  # 보안 그룹의 inbound 규칙을 적용, outbound는 위에서 모두 열어놨음
  resource "aws_security_group_rule" "project_security_ingress_internal"{
    type = "ingress"
    from_port = 0 # 모든 포트에 대해 들어오는 트래픽 허용
    to_port = 0 # 모든 포트에 대해 나가는 트래픽 허용
    protocol = "-1" # 모든 프로토콜에 대해 트래픽 허용
    source_security_group_id = aws_security_group.project_security.id # inbound 트래픽 출처가 될 보안그룹 지정
    security_group_id = aws_security_group.project_security.id # 이 규칙이 적용될 보안 그룹
    # -> 즉 project_security 보안 그룹에 속한 인스턴스들 간에 모든 포트와 프로토콜에 대해 자유롭게 통신할 수 있도록 허용
  }
