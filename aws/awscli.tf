resource "terraform_data" "awscli" {
  provisioner "local-exec" {
    command = <<EOF
set -e
sudo apt-get install python3.10-venv
WORKDIR=/tmp/aws
mkdir -p "$WORKDIR"
cd "$WORKDIR"
curl -f "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i "$WORKDIR"/aws
EOF
  interpreter = ["bash"]
  }
}
