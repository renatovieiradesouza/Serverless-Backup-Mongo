## Repository automations

## Configuração ELK Cloud  

Ambientes

**dev**
**stg**
**prod**

## Doc ELK
https://www.elastic.co/guide/en/beats/functionbeat/current/functionbeat-overview.html  
https://www.elastic.co/guide/en/beats/functionbeat/current/change-index-name.html  
https://www.elastic.co/guide/en/beats/functionbeat/current/configuration-template.html  
https://www.elastic.co/guide/en/beats/functionbeat/current/functionbeat-installation-configuration.html  
https://www.elastic.co/pt/blog/using-terraform-with-elastic-cloud  
https://www.elastic.co/guide/en/cloud/current/ec-restful-api.html  
https://www.elastic.co/guide/en/elasticsearch/reference/8.2/query-filter-context.html  

## Commom commands  
./functionbeat remove name_function  
./functionbeat update name_function  
./functionbeat -v -e -d "*" deploy name_function  
./functionbeat -v -e -d "*" deploy elkqitechdev -c functionbeat-dev-qi-tech.yml  
./functionbeat setup -e -c functionbeat-dev-qi-tech.yml  
./functionbeat update -c functionbeat-dev-qi-tech.yml  

## Backup Mongo Atlas Automation

## Arquitetura do projeto
![arquitetura do projeto](https://raw.githubusercontent.com/CondoLivre/infra-maintenance/main/mongoBackup/arquitetura/BackupMongoAtlasDB.png?token=GHSAT0AAAAAABWIW2NXOE76KFOZ7WLROMAKYY6Y4KQ)

