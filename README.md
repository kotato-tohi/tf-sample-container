# tf-sample-container 
ECSとALBでコンテナを用いたBlueGreenデプロイ可能なインフラ環境を構築

# DEMO
![container_service](https://user-images.githubusercontent.com/68144034/134936906-5849814b-8e16-4b87-ab59-c2f215282fd9.png)


# Features
各種リソースをmoduleとしてテンプレート化して
各環境用ディレクトリのmain.tfから呼び出す。



# Requirement 
* Terraform  v1.0.6

 
# Tree
 
```zsh
$ tree .
.
├── README.md
├── aws_templates
│   ├── alb
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── ecs
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── security
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── container_service.png
└── environments
    ├── dev
    │   ├── backend.tf
    │   ├── main.tf
    │   ├── output.tf
    │   ├── provider.tf
    │   ├── terraform.tfstate
    │   ├── terraform.tfstate.backup
    │   ├── terraform.tfvars
    │   └── variables.tf
    ├── prod
    │   ├── backend.tf
    │   ├── main.tf
    │   ├── output.tf
    │   ├── provider.tf
    │   └── variables.tf
    └── stg
        ├── backend.tf
        ├── main.tf
        ├── output.tf
        ├── provider.tf
        ├── terraform.tfstate
        ├── terraform.tfstate.backup
        ├── terraform.tfvars
        └── variables.tf

10 directories, 40 files

9 directories, 35 files
```
 
# Usage
```bash
git clone https://github.com/kotato-tohi/tf-sample-conteiner.git
cd tf-sample-container
terraform init
terraform plan
terrapform apply
```

## edit variables
* /environment/{dev|stg|prod}/terraform.tfvars


# Note
## subnetについて
* publicサブネットの数は必ず2以上にしてください。albの作成でエラーになります。
* publicサブネットとprivateサブネットは同じ数にしかできません。
* 作成されるazは1a,1b,1cの順番に作成されていきます。
* サブネットの数を増やすときは/environment/{dev|stg|prod}/terraform.tfvarsのsbn_cntで変更します.
* cidrは第3オクテットの0からインクリメントしていきます。先にpublicサブネットを割り当ててから、privateサブネットのcidrを割り振ります。

## securiry groupについて
* /aws_templates/securitu/mani.tfに各環境のルールを記載します。
* 三項演算子とcountを使いvar.env_tagの値がdevかstgかprodかによってinboundルールを切り替ます。

## target groupについて
* ALBのターゲットグループはBlue/Greenデプロイメント用に2つ作成します。
* ターゲットグループの作成数を変更するとCodeDeployの設定でエラーになります。

## IAMロールについて
* 環境差異の吸収が不十分で、各環境ごとに別名のロールが作成されます。
# Author 
* kotato-tohi