MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=dca1b857

--dca1b857
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

sed -i '/^CONTAINER_RUNTIME=/a CONTAINER_RUNTIME=\"containerd\"' /etc/eks/bootstrap.sh
--dca1b857--