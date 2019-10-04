data "template_file" "kube_manifests_templates" {
  template = "${file("${path.module}/manifests/<.yaml>")}"
}

resource "null_resource" "gltd-8ah-wordpress" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.kube_manifests_templates.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.kube_manifests_templates.rendered}\nEOF"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "kubectl delete -f -<<EOF\n${data.template_file.kube_manifests_templates.rendered}\nEOF"
  }
}