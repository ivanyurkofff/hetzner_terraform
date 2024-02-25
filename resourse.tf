resource "hcloud_ssh_key" "my_ssh_key" {
  name       = "my_server_key"
  public_key = file(var.path_pub_key)
}

resource "random_password" "password" {
  count            = var.number_servers
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "hcloud_server" "server_terraform" {
  count       = var.number_servers
  name        = "${var.server_name}-${count.index}"
  image       = "debian-11"
  server_type = "cx11"
  location    = "fsn1"
  ssh_keys    = [hcloud_ssh_key.my_ssh_key.id]


  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.path_private_key)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "/bin/echo -e \"root:${element(random_password.password[*].result, count.index)}\" | /usr/sbin/chpasswd "
    ]
  }
}


resource "local_file" "inventory" {
  filename = "./hosts"
  content  = templatefile("./template.tftpl", { ip_address = hcloud_server.server_terraform[*].ipv4_address, name = hcloud_server.server_terraform[*].name, key = var.path_private_key })
}
