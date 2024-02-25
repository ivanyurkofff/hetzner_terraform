output "password" {
  value = {
    for index, server in hcloud_server.server_terraform :
    server.name => {
      ipv4_address = hcloud_server.server_terraform[index].ipv4_address
      password     = nonsensitive(random_password.password[index].result)
    }
  }
}
