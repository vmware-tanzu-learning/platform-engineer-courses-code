#!/bin/bash +e

if [ -z "$PIVNET_TOKEN" ]; then
    echo "Must provide pivnet api token as environment variable PIVNET_TOKEN"
    exit 1
fi
ops_manager_version=2.10.4
platform_automation_version=5.0.12
files_directory=~/workspace/products

mkdir -p ${files_directory}

pivnet login --api-token $PIVNET_TOKEN

echo "Attempting to download Ops Manager version $ops_manager_version"
if [ ! -s ${files_directory}/ops-manager-vsphere-${ops_manager_version}*.ova ]; then
    pivnet download-product-files -p ops-manager -r ${ops_manager_version} -g "*.ova" -d ${files_directory}
else
  echo "Ops Manager version $ops_manager_version already exists"
fi

echo "Attempting to download Platform Automation Image version $platform_automation_version"
if [ ! -s ${files_directory}/vsphere-platform-automation-image-${platform_automation_version}.tgz ]; then
    pivnet download-product-files -p platform-automation -r ${platform_automation_version} -g *vsphere-platform-automation-image* -d ${files_directory}
else
  echo "Platform Automation Image version $platform_automation_version already exists"
fi    

