#!/bin/bash

#set -x

#Vars
bucket=$1
index=$2 #INDEX DO ELASTIC (development | staging | production)
cloudid=$3
elasticuser=$4
to_remove=$5 #somente quando deseja remover todas as subscriptions
count_log_groups_for_implement=`find temp -name "file.txt" | wc -l`
date_last_implementd=`date +'%F-%H%M%S'`

#Functions

send_msg_webhook(){
   curl -H 'Content-Type: application/json' -d "{\"text\": \"${1}\"}" https://livrefinanceira.webhook.office.com/webhookb2/356e4cab-c456-4560-9234-5b01b65bd872@b356ff48-3625-401d-8619-ccbdb542e5cd/IncomingWebhook/83fcf8e0163f4683b965ad89dd4b7b9d/d064d489-5b81-4e07-8e7f-cbd1ca322884
}

checking(){
    echo
    echo "#######################"
    echo "##Check before start##"
    echo "#######################"
    echo
    echo "#Bucket exist?"
    bucket_test=`aws s3 ls | egrep "${1}" | awk '{print $3}'`
    if [ "${bucket_test}" = "${1}" ]; then
        echo "yes"
    else
        echo "no exist, stop now!"
        exit 1
    fi
    echo
    echo "#Folder temp exist?"
    if [ -d "temp/" ]; then
        echo "yes"
    else
        echo "no, stop now!"
        exit 1
    fi
    echo
    mkdir -p temp/generate
}

generate_and_deploy(){
    for i in $(seq ${1})
    do

        line_log_group=`find temp -name "file.txt" | sed -n "${i}p"`
        path_log_group=`cat ${line_log_group}`

        if [ "$line_log_group" = "temp/others/file.txt" ]; then
            name_log_group="others"
        elif [ "$line_log_group" = "temp/ecs/file.txt" ]; then
            name_log_group="ecs"
        else 
            name_log_group=`awk '{print $3}' $line_log_group | cut -c 13-17 | sed 's/-//' | head -n 1`
        fi

        echo "functionbeat.provider.aws.endpoint: \"s3.amazonaws.com\"
functionbeat.provider.aws.deploy_bucket: \"${2}\"
functionbeat.provider.aws.functions:
   - name: elk${name_log_group}
     enabled: true
     type: cloudwatch_logs
     description: \"Função lambda para capturar log das funções da conta de produção condo\"
     memory_size: 128MiB
     fields:
     env: ${3}
     triggers:
${path_log_group}

setup.template.name: \"${3}\"
setup.template.pattern: \"${3}\"
setup.template.settings:
setup.kibana:

cloud.id: \"${4}\"
cloud.auth: \"${5}\"

output.elasticsearch:  
    hosts: [\"localhost:9200\"]
    index: \"${3}\"
processors:
    - add_host_metadata: ~
    - add_cloud_metadata: ~ " > temp/generate/"elk"$name_log_group.yml

        log=`echo "${path_log_group}" | sed 's/      //' | sed 's/- log_group_name:/aws logs describe-subscription-filters --log-group-name/'`
        countLog=`echo "${log}" | wc -l`
        validate_elk_lambda_mother=`echo elk$name_log_group | sed 's/elkelk.*/bypass/'`
        
        without_subscription=0
        with_subscription=0

        for i in $(seq $countLog)
        do
            mount_cli=`echo "${log}" | sed -n "${i}p"`
            echo $mount_cli
            run_=`$mount_cli | egrep logGroupName`

            if [ $? -eq 0 ]; then
                let with_subscription=with_subscription+1
            else
                let without_subscription=without_subscription+1
            fi

            echo $run_
        done

        echo "with_subscription $with_subscription"
        echo "without_subscription $without_subscription"
        
        if [[ "$without_subscription" -gt 0 ]]; then

            if [[ "${validate_elk_lambda_mother}" = "bypass" ]]; then
                echo "Bypass lambda Elastic"
            else
                send_msg_webhook "$name_log_group  - ${2} -  without_subscription $without_subscription"
            fi

        fi

        if [ "${6}" = "remove" ]; then
        
            if [[ "${validate_elk_lambda_mother}" = "bypass" ]]; then

                echo "Bypass lambda Elastic"

            else

                echo "removendo $name_log_group"
                ./functionbeat -v -e -d '*' remove "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml > /dev/null
        
            fi

        elif [[ "$with_subscription" -gt 0 && "$without_subscription" -gt 0 ]]; then
            
            echo "Running update: $name_log_group"
            
            if [[ "${validate_elk_lambda_mother}" = "bypass" ]]; then

                echo "Bypass lambda Elastic"

            else

                chmod +x functionbeat
                ./functionbeat -v -e -d '*' update "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml > /dev/null
                #Verificar retorno com $? e notificar em caso de erro no teams

            fi
        
        elif [[ "$with_subscription" -eq 0 && "$without_subscription" -gt 0 ]]; then

            echo "Running deploy: $name_log_group"

            if [[ "${validate_elk_lambda_mother}" = "bypass" ]]; then
                
                echo "Bypass lambda Elastic"

            else

                chmod +x functionbeat
                ./functionbeat -v -e -d '*' deploy "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml > /dev/null

            fi
        else
            echo "Nothing now"
        fi

    done
}

checking $bucket 

generate_and_deploy $count_log_groups_for_implement $bucket $index $cloudid $elasticuser $to_remove

