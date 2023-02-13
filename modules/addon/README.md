# Terraform module

- addon.tf : AWS Add-on 생성
- kubernetes_resources.tf : [terraform kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)를 통해 사전에 선언한 manifest 등을 적용
- varialbes.tf : input value
- iam.tf : addon 설치에 필요한 oidc 연동 iam 생성
- kms.tf : ebs에 암호화를 적용할 경우 aws/ebs kms 또는 kms를 신규 생성하여 적용
- locals.tf : 지역 변수 선언
- templates.tf : kms 또는 policy 템플릿 변수 값 치환
- data_for_ebs_encrypt.tf : kms 및 policy 생성에 필요한 설정 값
- policy_attachment : 생성한 iam role에 aws managed policy를 할당하기 위한 모듈

## module variables

[참조](./../../docs/eks_addons.md)

## Terraform `aws_eks_addon` variables

[참조](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon)

| 항목                     | 필수 | 설명                                                                                                 |
| ------------------------ | ---- | ---------------------------------------------------------------------------------------------------- |
| addon_name               | O    | Amazon EKS에서 지원하는 AddOn 이름 </br>`--describe-addon-versions`을 실행하여 확인할 수 있다        |
| cluster_name             | O    | Add On을 배포하고자 하는 Amazon EKS 클러스터 이름                                                    |
| addon_version            | X    | Amazon EKS에서 지원하는 AddOn 버전 </br>`--describe-addon-versions`을 실행하여 확인할 수 있다        |
| resolve_conflicts        | X    | Amazon EKS에 이미 동일한 Add On이 배포되어 있는 경우 배포 방식 </br> `NONE`, `OVERWRITE`만 설정 가능 |
| tags                     | X    |                                                                                                      |
| default_tags             | X    |                                                                                                      |
| preserve                 | X    | `terraform destroy`를 실행 시, EKS에서 해당 Add On의 삭제 여부 </br>`default : ture`                 |
| service_account_role_arn | X    | IAM의 ARN                                                                                            |
