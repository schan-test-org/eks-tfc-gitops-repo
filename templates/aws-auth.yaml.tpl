apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${eks_node_group_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
%{ if length(iam_roles) > 0 ~}
%{ for iam_role in iam_roles ~}
    - rolearn: ${iam_role.iam_role_arn}
      username: ${iam_role.user_name}
      groups:
%{ for role in iam_role.roles ~}      
        - ${role}
%{ endfor ~}
%{ endfor ~}
%{ endif  ~}
  mapUsers: |
%{ if length(iam_users) > 0 ~}
%{ for user in iam_users ~}
    - userarn: arn:aws:iam::${account_id}:user/${user.user_name}
      username: ${user.user_name}
      groups:
%{ for role in user.roles ~}      
      - ${role}
%{ endfor ~}
%{ endfor ~}
%{ endif  ~}