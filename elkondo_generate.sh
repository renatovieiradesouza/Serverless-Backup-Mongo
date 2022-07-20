#!/bin/bash

#  cada novo deploy, valida se já foi implanted, caso não, segue toda esteira
#  caso já tenha sido. roda update

#Vars
bucket=$1 #("elk-condolivre-dev" "elk-condolivre-stg" "elk-condolivre-prod")
index=$2 #INDEX DO ELASTIC (development | staging | production)
cloudid=$3 #ELK_CondoLivre:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyQ5Y2ExOGQ0Nzk2YzY0MmYyOWU5ZTczY2E1ZTcwYjgwZSQ5YWIyNDFiMjBhNzg0MTMwOGM2ZTJhNGQ4ODZlMzUwYQ==
elasticuser=$4 #elastic:H8rE2xkLwEuT8VZTueStdQbL


count_log_groups_for_implement=`find temp -name "file.txt" | wc -l`
date_last_implementd=`date +'%F-%H%M%S'`
mkdir -p temp/$date_last_implementd

echo
echo "#######################"
echo "##Check before start##"
echo "#######################"
echo
echo "#Bucket exist?"
bucket_test=`aws s3 ls | egrep "elk-condolivre-prod" | awk '{print $3}'`
if [ ${bucket_test} = ${bucket} ]; then
    echo "yes"
else
    echo "no, stop now!"
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
  - add_cloud_metadata: ~ " > temp/$date_last_implementd/"elk"$name_log_group.yml
done

