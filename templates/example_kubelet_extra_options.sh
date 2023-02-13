MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=ee0528e8

--ee0528e8
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

sed -i '/^KUBELET_EXTRA_ARGS=/a KUBELET_EXTRA_ARGS+=\" --allowed-unsafe-sysctls 'net.core.somaxconn,net.netfilter.nf_conntrack_tcp_be_liberal' \"' /etc/eks/bootstrap.sh
--ee0528e8--