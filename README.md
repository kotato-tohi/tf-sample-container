# tf-sample-container 
ECSとALBでコンテナを用いたインフラ環境を構築

# DEMO
![container_service](https://user-images.githubusercontent.com/68144034/134936906-5849814b-8e16-4b87-ab59-c2f215282fd9.png)


# Features
各種リソースをmoduleとしてテンプレート化し
各環境用のmain.tfから呼び出すことで複数環境の構築を行う。

# Requirement 
* Terraform  v1.0.6

 
# Installation
 
```zsh

```
 
# Usage
## clone
```bash
git clone https://github.com/kotato-tohi/tf-sample-conteiner.git
```

## edit variables
* /environment/{dev|stg|prod}/terraform.tfvars


# Note
## subnetについて
* publicサブネットとprivateサブネットは同じ数にしかできません.
* 作成されるazは1a,1b,1cの順番に作成されていきます.
* サブネットの数を増やすときは/environment/{dev|stg|prod}/terraform.tfvarsのsbn_cntで変更します.
* cidrは第3オクテットの0からインクリメントしていきます。先にpublicサブネットを割り当ててから、privateサブネットのcidrを割り振ります.

## securiry groupについて
* /aws_templates/securitu/mani.tfに各環境のルールを記載します。
* 三項演算子とcountを使いvar.env_tagの値がdevかstgかprodかによってinboundルールを切り替える

# Author 
* kotato-tohi