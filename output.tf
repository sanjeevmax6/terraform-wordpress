# Output to display the private IP addresses of all created EC2 instances
# The [*] syntax allows for multiple instances if count or for_each is used
output "public_ip" {
  value = {
    public_ip = aws_instance.my_server.public_ip
    private_ip = aws_instance.my_server.private_ip
  }
  description = "Public IP of EC2 instance"
}