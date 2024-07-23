provider "aws" {
    region = "ap-south-1"
}

module "ec2" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git/EC2"
    instance_ami = "ami-0ec0e125bb6c6e8ec"
    instance_type = "t2.micro"
    subnet_id = "subnet-0hgg....."
    associate_public_ip_address = true
    availability_zone = "ap-south-1a"
    root_ebs_delete_on_termination = true
    root_ebs_encryption = true
    root_ebs_iops = 100
    root_ebs_volume_name = "test_ebs"
    root_ebs_throughput = 1
    root_ebs_volume_type = "gp3"
    attach_role_instance = true
    instance_profile_name = "ec2instanceprofilerole"
    instance_role_name = "ec2_instance_role"
    iam_policy_json_file = false
    key_pair_name = "test_instance_key_pair"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    security_group_name = "test_instance_sg"
    security_group_inbound_port = ["22","80"]
    sg_ip_protocol = "tcp"
    vpc_id = "vpc-00...." 
    user_data_requried_or_not = false
    attach_ebs_requried_or_not = false
    vpc_ipv4_cidr_block = "0.0.0.0/0"
}