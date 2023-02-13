# User data 사용법

## Shell scripts 생성

다음과 같이 userdata용 Shell scripts 를 생성한다.

```sh
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=ee0528e8

--ee0528e8
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

# 사용자 명령어를 나열한다.
sed -i '/^KUBELET_EXTRA_ARGS=/a KUBELET_EXTRA_ARGS+=\" --allowed-unsafe-sysctls 'net.core.somaxconn,net.netfilter.nf_conntrack_tcp_be_liberal' \"' /etc/eks/bootstrap.sh
--ee0528e8--
```

예제의 `ee0528e8` 값은 boundary 구분 짓는 구분 값으로 scripts 별 고유 값을 생성하여 부여한다.

```sh
# boundary 구분자 고유값 생성
uuidgen
```

## Terraform Code에 적용

Scripts를 base64로 변환 적용한다.

```js
resource "aws_launch_template" "nodegroup" {

  ...

  user_data = "${base64encode(file("${path.module}/templates/example_insecure_docker_registry.sh"))}"

  ...

}
```