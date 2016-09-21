output "jumpbox_address" {
  value = "${openstack_compute_floatingip_v2.jumpbox_host_ip.address}"
}

output "server_names" {
	value = ["${list(openstack_compute_instance_v2.jumpbox_host.name)}"]
}