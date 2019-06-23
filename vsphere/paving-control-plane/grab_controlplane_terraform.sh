#!/bin/bash

mkdir ~/workspace/paving-control-plane
cd ~/workspace/paving-control-plane
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/concourse_lb.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/lb.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/minio_lb.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/nsx-t-network.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/nsxt-data.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/provider.tf
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/terraform.tfvars
wget https://raw.githubusercontent.com/platform-acceleration-lab/pal-course-platform-engineers-code/master/vsphere/paving-control-plane/variables.tf