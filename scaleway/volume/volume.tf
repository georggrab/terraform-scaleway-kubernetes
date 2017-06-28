variable "for_servers" { type = "list" }
variable "count" {}
variable "volume_size" {}
variable "enabled" {}

resource "scaleway_volume" "volume" {
    count = "${var.enabled? var.count : 0}"
    name  = "kube-data-${count.index}"
    size_in_gb  = "${var.volume_size}"
    type  = "l_ssd"
}

resource "scaleway_volume_attachment" "volume-attachment" {
    count = "${var.enabled? var.count : 0}"
    server = "${element(var.for_servers, count.index)}"
    volume = "${element(scaleway_volume.volume.*.id, count.index)}"
}

output "volume_ids" {
    value = ["${scaleway_volume.volume.*.id}"]
}

output "volume_attachment_ids" {
    value = ["${scaleway_volume_attachment.volume-attachment.*.id}"]
}