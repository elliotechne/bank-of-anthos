data "template_file" "main" {
  template = <<EOF
set -e
WORKDIR=/tmp/${uuid()}
mkdir -p "$WORKDIR"
cd "$WORKDIR"
curl -f "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i "$WORKDIR"/aws
EOF
}

output "script" {
  value = "${data.template_file.main.rendered}"
}
