#!/bin/bash
rm -Rf tools/
mkdir -p tmp tools
curl -o tmp/terraform.zip https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip
unzip tmp/terraform.zip -d tools
chmod u+x tools/terraform
