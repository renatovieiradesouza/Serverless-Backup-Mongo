#!/bin/bash

#Var devem vir do github variaveis
env_ecs="prod"
env_ecs_rule="production" #Apply between stg and prod. For stg use staging and prod use production

predefined_groups_lambdas=("/aws/lambda/cara-cracha" "/aws/lambda/condo-loan-asyc" "/aws/lambda/qi-tech" "/aws/lambda/serverless" "/aws/lambda/singularity" "/aws/lambda/supply" "/aws/lambda/tonyhawk" "/aws/lambda/townhall")

#Functions

get_log_group_from_aws_cli(){
    echo "##################"
    echo "Get all Logs from aws account"
    echo "##################"
    aws logs describe-log-groups > log.json

    #Checking file log.json is ok
    if [ ! -f log.json ]; then

        echo "##################"
        echo "Get all Logs from aws account AGAIN!"
        echo "##################"
        aws logs describe-log-groups > log.json

    fi
}

get_log_group_lambdas_from_file(){

    echo
    echo "##################"
    echo "Prepare temp folder for log group -> ${1}"
    echo "##################"
    echo 
    folder_temp="temp/${1}"
    mkdir -p $folder_temp
    if [ -d "temp/" ]; then
        echo "Folder is created"
    fi
    echo
    echo "##################"
    echo "Numbers of itens for log group -> ${1}"
    echo "##################"
    echo 
    egrep -c "\"logGroupName\": \"${1}-.*" log.json
    echo 
    echo "##################"
    echo "Itens for log group -> ${1}"
    echo "##################"
    echo 
    egrep "\"logGroupName\": \"${1}-.*" log.json | sed 's/"logGroupName"/- log_group_name/' | sed 's/"//' | sed 's/",//' | sed 's/            /      /' > $folder_temp/file.txt
    cat $folder_temp/file.txt
}

#Get Others log groups
get_log_group_from_file_others(){
    
    echo
    echo "##################"
    echo "Prepare temp folder for log group -> Others"
    echo "##################"
    echo 
    
    folder_temp="temp/others"
    mkdir -p $folder_temp
    if [ -d "temp/" ]; then
        echo "Folder is created"
    fi

    echo 
    echo "##################"
    echo "Itens for log group -> Others"
    echo "##################"
    echo 
    
    egrep 'logGroupName' log.json | sed 's/\"logGroupName\": \"\/aws\/lambda\/.*//' | sed -e "s/\"logGroupName\": \"${env_ecs_rule}.*//" | sed -e "s/\"logGroupName\": \"${env_ecs}.*//" | sed 's/"logGroupName"/- log_group_name/' | sed 's/"//' | sed 's/",//' | sed 's/            /      /' |  sed '/^[[:space:]]*$/d' > $folder_temp/file.txt
    cat $folder_temp/file.txt

}

get_log_group_ecs_from_file(){
    
    echo
    echo "##################"
    echo "Prepare temp folder for log group -> ECS"
    echo "##################"
    echo 
    
    folder_temp="temp/ecs"
    mkdir -p $folder_temp
    if [ -d "temp/" ]; then
        echo "Folder is created"
    fi

    echo 
    echo "##################"
    echo "Itens for log group ->  ECS"
    echo "##################"
    echo 
    
    egrep "\"logGroupName\": \"${env_ecs}-" log.json | sed 's/\"logGroupName\": \"\/aws\/lambda\/.*//' | sed 's/"logGroupName"/- log_group_name/' | sed 's/"//' | sed 's/",//'  | sed 's/            /      /' |  sed '/^[[:space:]]*$/d' > $folder_temp/file.txt
    cat $folder_temp/file.txt

}

#Start process

#Getin data from aws
get_log_group_from_aws_cli

#Getin log group lambdas
for i in "${predefined_groups_lambdas[@]}"
do
    get_log_group_lambdas_from_file $i
done

#Getin log group others
get_log_group_from_file_others

#Getin log group ECS
get_log_group_ecs_from_file




