#!/bin/bash
# http://apetec.com/support/GenerateSAN-CSR.htm
# https://rtcamp.com/wordpress-nginx/tutorials/ssl/multidomain-ssl-subject-alternative-names/
# http://wiki.samat.org/CheatSheet/OpenSSL

rm -rf tls/*.pem || mkdir -p tls
rm -rf tls/*.srl

cd tls

echo 'Creating CA (ca-key.pem, ca.pem)'
echo 01 > ca.srl
openssl genrsa -des3 -passout pass:password -out ca-key.pem 2048
openssl req -new -passin pass:password \
        -subj '/CN=Non-Prod Test CA/C=US' \
        -x509 -days 365 -key ca-key.pem -out ca.pem


echo 'Creating Swarm certificates (swarm-key.pem, swarm-cert.pem)'
openssl genrsa -des3 -passout pass:password -out swarm-key.pem 2048
openssl req -passin pass:password -subj '/CN=dockerswarm01' -new -key swarm-key.pem -out swarm-client.csr
echo 'extendedKeyUsage = clientAuth,serverAuth' > extfile.cnf
openssl x509 -passin pass:password -req -days 365 -in swarm-client.csr -CA ca.pem -CAkey ca-key.pem -out swarm-cert.pem -extfile extfile.cnf
openssl rsa -passin pass:password -in swarm-key.pem -out swarm-key.pem

# Set the default keys to be Swarm
cp -rp swarm-key.pem key.pem
cp -rp swarm-cert.pem cert.pem

echo 'Creating host certificates (dockerhost01-3-key.pem, dockerhost01-3-cert.pem)'
openssl genrsa -passout pass:password -des3 -out dockerhost01-key.pem 2048
openssl req -passin pass:password -subj '/CN=dockerhost01' -new -key dockerhost01-key.pem -out dockerhost01.csr
openssl x509 -passin pass:password -req -days 365 -in dockerhost01.csr -CA ca.pem -CAkey ca-key.pem -out dockerhost01-cert.pem -extfile openssl.cnf
openssl rsa -passin pass:password -in dockerhost01-key.pem -out dockerhost01-key.pem

openssl genrsa -passout pass:password -des3 -out dockerhost02-key.pem 2048
openssl req -passin pass:password -subj '/CN=dockerhost02' -new -key dockerhost02-key.pem -out dockerhost02.csr
openssl x509 -passin pass:password -req -days 365 -in dockerhost02.csr -CA ca.pem -CAkey ca-key.pem -out dockerhost02-cert.pem -extfile openssl.cnf
openssl rsa -passin pass:password -in dockerhost02-key.pem -out dockerhost02-key.pem

openssl genrsa -passout pass:password -des3 -out dockerhost03-key.pem 2048
openssl req -passin pass:password -subj '/CN=dockerhost03' -new -key dockerhost03-key.pem -out dockerhost03.csr
openssl x509 -passin pass:password -req -days 365 -in dockerhost03.csr -CA ca.pem -CAkey ca-key.pem -out dockerhost03-cert.pem -extfile openssl.cnf
openssl rsa -passin pass:password -in dockerhost03-key.pem -out dockerhost03-key.pem

rm -f *.csr

rm -rf ../ansible/roles/docker/files/tls
mkdir -p ../ansible/roles/docker/files/tls
mv docker* ../ansible/roles/docker/files/tls/
cp -rp ca.pem ../ansible/roles/docker/files/tls/

rm -rf ../ansible/roles/docker_swarm/files/tls
mkdir -p ../ansible/roles/docker_swarm/files/tls
mv swarm* ../ansible/roles/docker_swarm/files/tls/
cp -rp ca.pem ../ansible/roles/docker_swarm/files/tls/
