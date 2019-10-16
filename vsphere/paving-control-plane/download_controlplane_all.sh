#!/bin/bash +e

if [ -z "$PIVNET_TOKEN" ]; then
    echo "Must provide pivnet api token as environment variable PIVNET_TOKEN"
    exit 1
fi
ops_manager_version=2.7.1
controlplane_version=1.0.3-beta.1
controlplane_stemcell_version=315.70
platform_automation_version=4.0.3
minio_version=1.0.6
minio_stemcell_version=315.41
files_directory=~/Downloads

mkdir -p ${files_directory}

pivnet login --api-token $PIVNET_TOKEN

echo "Attempting to download Ops Manager version $ops_manager_version"
if [ ! -s ${files_directory}/ops-manager-vsphere-${ops_manager_version}*.ova ]; then
    pivnet download-product-files -p ops-manager -r ${ops_manager_version} -g "*.ova" -d ${files_directory}
else
  echo "Ops Manager version $ops_manager_version already exists"
fi
echo "Attempting to download Platform Automation Engine Tile version $controlplane_version"
if [ ! -s ${files_directory}/control-plane-${controlplane_version}*.pivotal ]; then
    pivnet download-product-files -p p-control-plane-components -r ${controlplane_version} -g "*.pivotal" -d ${files_directory}
else
  echo "Platform Automation Engine Tile version $controlplane_version already exists"
fi
echo "Attempting to download Stemcell version $controlplane_stemcell_version"
if [ ! -s ${files_directory}/bosh-stemcell-${controlplane_stemcell_version}-*.tgz ]; then
    pivnet download-product-files -p stemcells-ubuntu-xenial -r ${controlplane_stemcell_version} -g *vsphere* -d ${files_directory}
else
  echo "Stemcell version $controlplane_stemcell_version already exists"
fi
echo "Attempting to download Stemcell version $minio_stemcell_version"
if [ ! -s ${files_directory}/bosh-stemcell-${minio_stemcell_version}-*.tgz ]; then
    pivnet download-product-files -p stemcells-ubuntu-xenial -r ${minio_stemcell_version} -g *vsphere* -d ${files_directory}
else
  echo "Stemcell version $minio_stemcell_version already exists"
fi
echo "Attempting to download Platform Automation Image version $platform_automation_version"
if [ ! -s ${files_directory}/platform-automation-image-${platform_automation_version}.tgz ]; then
    pivnet download-product-files -p platform-automation -r ${platform_automation_version} -g *platform-automation-image* -d ${files_directory}
else
  echo "Platform Automation Image version $platform_automation_version already exists"
fi    
echo "Attempting to download Minio tile version $minio_version"
if [ ! -s ${files_directory}/minio-internal-blobstore-${minio_version}*.pivotal ]; then
    pivnet download-product-files -p minio-internal-blobstore -r ${minio_version} -g "*.pivotal" -d ${files_directory}
else
  echo "Minio tile version $minio_version already exists"
fi
