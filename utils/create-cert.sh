#!/usr/bin/env bash
#
# This script generates a new SSL certificate and key for a given domain,
# signed by a local, private certificate authority. If the CA certificate
# and key do not exist then they will also be created.
#
# The domain certificate has subject alternate names for the common
# sub-domains used for a TAS foundation.
#
# DO NOT USE THIS FOR PRODUCTION ENVIRONMENTS!

set -e

baseDN="/C=US/ST=CA/L=Palo Alto/O=VMware Inc./OU=Tanzu"
lifetime=365

rootCert="rootCA.crt"
rootKey="rootCA.key"

if [[ ! -f rootCA.crt ]]
then
  echo "No root CA certificate found, generating a new cert/key pair"
  openssl genrsa -out $rootKey 2048
  openssl req -x509 -new -nodes -key $rootKey -sha256 -days $lifetime -subj "$baseDN/CN=Self-Signed Root CA" -out $rootCert
  echo "Root CA certificate: $rootCert"
  echo "Root CA private key: $rootKey"
else
  echo "Using existing root CA certificate: $rootCert"
fi
echo "---"

if [[ -z "$1" ]]
then
  echo "Usage: $0 [domain-name]"
  echo "Please supply a domain to create a certificate for";
  echo "e.g. mysite.com or 1.2.3.4.nip.io"
  exit
fi

domain=$1
subject="$baseDN/CN=$domain"

extFile=$domain.v3.ext
cat > $extFile <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $domain
DNS.2 = *.sys.$domain
DNS.3 = *.apps.$domain
DNS.4 = uaa.sys.$domain
DNS.5 = *.uaa.sys.$domain
DNS.6 = login.sys.$domain
DNS.7 = *.login.sys.$domain
EOF

openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout $domain.key -subj "$subject" -out $domain.csr
openssl x509 -req -in $domain.csr -CA $rootCert -CAkey $rootKey -CAcreateserial -out $domain.crt -days $lifetime -sha256 -extfile $extFile

echo "---"
echo "New certificate successully generated"
echo "Private key: $domain.key"
echo "Certificate: $domain.crt"

