#!/usr/bin/env bash

ADMIN_KEY=$(openssl rand -hex 32 2>&1)
VIEWER_KEY=$(openssl rand -hex 32 2>&1)
echo " ADMIN_KEY is: \`${ADMIN_KEY}\` \nVIEWER_KEY is: \`${VIEWER_KEY}\`"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add apisix https://charts.apiseven.com
helm repo update
# Apache APISIX as the proxy plane of apisix-ingress-controller, should be deployed in advance.
helm install apisix apisix/apisix --namespace kube-system --set admin.allow.ipList="{0.0.0.0/0}" \
--set admin.credentials.admin="${ADMIN_KEY}" \
--set admin.credentials.viewer="${VIEWER_KEY}"

helm install apisix-ingress-controller apisix/apisix-ingress-controller  \
  --set config.apisix.baseURL=http://apisix-admin:9180/apisix/admin \
  --set config.apisix.adminKey=${ADMIN_KEY} \
  --set image.tag="1.1.0"
  --namespace kube-system