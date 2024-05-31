resource "random_string" "userpasswd" {
  special = true
  length = 16
}

output "userpasswd" {
  value = random_string.userpasswd.id
}
