#!/bin/bash

#set -x

#  cada novo deploy, valida se já foi implanted, caso não, segue toda esteira
#  caso já tenha sido. roda update

#Vars
bucket=$1 #("elk-condolivre-dev" "elk-condolivre-stg" "elk-condolivre-prod")
index=$2 #INDEX DO ELASTIC (development | staging | production)
cloudid=$3 #ELK_CondoLivre:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyQ5Y2ExOGQ0Nzk2YzY0MmYyOWU5ZTczY2E1ZTcwYjgwZSQ5YWIyNDFiMjBhNzg0MTMwOGM2ZTJhNGQ4ODZlMzUwYQ==
elasticuser=$4 #elastic:H8rE2xkLwEuT8VZTueStdQbL
to_remove=$5 #somente quando deseja remover todas as subscriptions


count_log_groups_for_implement=`find temp -name "file.txt" | wc -l`
date_last_implementd=`date +'%F-%H%M%S'`


echo
echo "#######################"
echo "##Check before start##"
echo "#######################"
echo
echo "#Bucket exist?"
bucket_test=`aws s3 ls | egrep "${bucket}" | awk '{print $3}'`
if [ "${bucket_test}" = "${bucket}" ]; then
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

for i in $(seq $count_log_groups_for_implement)
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
functionbeat.provider.aws.deploy_bucket: \"${bucket}\"
functionbeat.provider.aws.functions:
  - name: elk${name_log_group}
    enabled: true
    type: cloudwatch_logs
    description: \"Função lambda para capturar log das funções da conta de produção condo\"
    memory_size: 128MiB
    fields:
    env: ${index}
    triggers:
${path_log_group}

setup.template.name: \"${index}\"
setup.template.pattern: \"${index}\"
setup.template.settings:
setup.kibana:

cloud.id: \"${cloudid}\"
cloud.auth: \"${elasticuser}\"

output.elasticsearch:  
  hosts: [\"localhost:9200\"]
  index: \"${index}\"
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~ " > temp/generate/"elk"$name_log_group.yml

    log=`echo "${path_log_group}" | sed 's/      //' | sed 's/- log_group_name:/aws logs describe-subscription-filters --log-group-name/'`
    countLog=`echo "${log}" | wc -l`
    
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

        #run_=`$mount_cli | egrep logGroupName  > /dev/null`
        echo $run_
    done

    echo "with_subscription $with_subscription"
    echo "without_subscription $without_subscription"

    if [[ "$with_subscription" -gt 0 && "$without_subscription" -gt 0 ]]; then
        chmod +x functionbeat
        echo "Running update: $name_log_group"
        ./functionbeat-8.3.2-linux-x86_64/functionbeat -v -e -d '*' update "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml
        #Verificar retorno com $? e notificar em caso de erro no teams
    elif [[ "$with_subscription" -eq 0 && "$without_subscription" -gt 0 ]]; then
        chmod +x functionbeat
        echo "Running deploy: $name_log_group"
        ./functionbeat-8.3.2-linux-x86_64/functionbeat -v -e -d '*' deploy "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml 
         #Verificar retorno com $? e notificar em caso de erro no teams    
    elif [ "${to_remove}" = "remove" ]; then
        echo "removendo $name_log_group"
        ./functionbeat-8.3.2-linux-x86_64/functionbeat -v -e -d '*' remove "elk"$name_log_group -c temp/generate/"elk"$name_log_group.yml 
    else
        echo "Nothing now"
    fi

done