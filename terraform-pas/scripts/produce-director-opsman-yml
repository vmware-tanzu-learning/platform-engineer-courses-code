#!/bin/bash -exu

texplate execute $PROJECT_DIR/ci/assets/template/director-config.yml \
  -f  <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' terraform.tfstate) \
  -o yaml \
  > director.yml

texplate execute $PROJECT_DIR/ci/assets/template/opsman-config.yml \
  -f  <(jq -e --raw-output '.modules[0].outputs | map_values(.value)' terraform.tfstate) \
  -o yaml \
  > opsman.yml

