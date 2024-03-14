resource "aws_ecr_repository" "ecr_repository" {
  count        = length(var.service_name)
  name         = "${var.service_name[count.index]}${terraform.workspace == "producao" ? "" : terraform.workspace == "homologacao" ? "-hom" : ""}"
  force_delete = true
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
}