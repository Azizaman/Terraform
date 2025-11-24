terraform-3tier/
├── backend.tf                    # remote state backend config (S3 + Dynamo)
├── providers.tf                  # provider(s) config (aws)
├── versions.tf                   # required_version & provider versions
├── variables.tf                  # global variables (env, region, common tags)
├── terraform.tfvars              # secrets / environment specific values (gitignored)
├── envs/
│   ├── prod/
│   │   └── terraform.tfvars
│   └── dev/
│       └── terraform.tfvars
├── main.tf                       # root composition: module calls
├── outputs.tf                    # root outputs
├── modules/
│   ├── network/                  # VPC, subnets, route tables, IGW, NAT GW
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/                 # security groups, NACLs
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/                      # ALB + target groups + listeners
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── autoscaling/              # Auto Scaling Group or ASG with launch template
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2-bastion/              # optional bastion host in public subnet
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/                      # database (RDS/Postgres/MySQL) in private subnets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam/                      # roles, policies (instance profile, service roles)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/               # cloudwatch, logs, alarms
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── modules-docs.md               # optional notes & usage examples
