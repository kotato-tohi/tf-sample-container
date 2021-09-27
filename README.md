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
 
# Author 
* kotato-tohi