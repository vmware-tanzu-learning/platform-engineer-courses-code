bosh deploy --deployment concourse concourse.yml \
  --vars-file ../versions.yml \
  --vars-file concourse-vars-file.yml \
  --ops-file operations/basic-auth.yml \
  --ops-file operations/privileged-http.yml \
  --ops-file operations/privileged-https.yml \
  --ops-file operations/tls.yml \
  --ops-file operations/tls-vars.yml \
  --ops-file operations/web-network-extension.yml \
  --ops-file operations/scale.yml
