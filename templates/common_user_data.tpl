MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -e
CLUSTER_NAME=${cluster_name}
B64_CLUSTER_CA=${cluster_auth_base64}
API_SERVER_URL=${endpoint}
KUBELET_EXTRA_ARGS=${kubelet_extra_args}
BOOTSTRAP_EXTRA_ARGS=${bootstrap_extra_args}
K8S_CLUSTER_DNS_IP=10.100.0.10

/etc/eks/bootstrap.sh $CLUSTER_NAME --kubelet-extra-args '${kubelet_extra_args}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP
--//--