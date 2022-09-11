## Repository automations

<details>
    <summary>ELK Automation</summary>
    ### Configuração ELK Cloud  

    Ambientes

    dev
    stg
    prod

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
</details>

<details>
    <summary>Backup Mongo Atlas Automation</summary>
    
</details>

