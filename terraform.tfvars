resource "packet_ssh_key" "admin" {
   name = "admin_key"
   public_key = file("~/.ssh/id_ed25519.pub")
   public_key = file("${var.ssh_key}.pub")
 }
 
 facility         = "ams1"
 operating_system = "ubuntu_16_04_image"
 
resource "packet_device" "swarm_master" {
   hostname         = "swarm-master"
   plan             = var.plan
   facility         = var.facility
   operating_system = var.operating_system
   billing_cycle    = "hourly"
   project_id       = packet_project.swarm.id
}
provisioner "remote-exec" {
   connection {
     user        = var.ssh_username
     private_key = file("${var.ssh_key}")
   }
   scripts = [
     "scripts/update_os.sh",
     "scripts/install_docker.sh",
   ]
   inline = [
     "docker swarm init --advertise-addr ${packet_device.swarm_master.network.2.address}",
   ]
}
provisioner "local-exec" {
   command = "ssh -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.ssh_key} ${var.ssh_username}@${packet 
}
