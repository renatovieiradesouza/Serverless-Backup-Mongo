#!/bin/bash

check_and_execute_log_group_subscription(){

    echo "##################"
    echo "Check Subscription log"
    echo "##################"

    log_group=${1}
    filename=$log_group
    sed -i -e '$a\' $filename
    n=0
    count_ok=0
    count_not_ok=0
    
    while read line; do
    
    # reading each line
    novaLinha=`echo $line | sed 's/- log_group_name: //g'`
    
    aws logs describe-subscription-filters --log-group-name $novaLinha | egrep logGroupName > /dev/null

    if [ $? -eq 0 ]; then
        echo "LogGroup is ok -> ${i}"
        let count_ok=count_ok+1
    else
        echo "LogGroup not ok -> ${i}"
        let count_not_ok=count_not_ok+1
    fi
    n=$((n+1))
    done < $filename

    echo "existe -> $count_ok"
    echo "nao existe -> $count_not_ok"

    #Check for deploy, update or remove 

    if [[ "$count_not_ok" -gt 0 && "$count_ok" -gt 0 ]]; then
        chmod +x functionbeat
        ./functionbeat -v -e -d '*' update ${2} -c ${3}
    elif [ "$count_ok" -eq 0 ]; then
        chmod +x functionbeat
        ./functionbeat -v -e -d '*' deploy ${2} -c ${3}      
    fi

}

#TODO get info for remove

#get info for deploy/update
path=""
name_function=""
counter=`ls temp/20* | wc -l`
pathTxt=`ls temp/ | sed 's/[0-9].*//' | sed '/^[[:space:]]*$/d'`
pathElks=`ls temp/20* | sed 's/[0-9].*//' | sed '/^[[:space:]]*$/d'`
#pathTxt=("cara-c" "condo-" "ecs" "elkcon")

for i in ${pathTxt[@]}
do
    #echo $i
    #echo "elk${i}" | cut -c 1-9 | sed 's/-//'
    #echo "temp/${i}/file.txt"
    #| sed 's/\.yml//' | sed 's/tem.*//g' | sed 's/fil.*//' | sed '/^[[:space:]]*$/d'
    #name_function=`echo $i  | sed 's/\.yml//' | sed 's/tem.*//g' | sed 's/fil.*//' | sed '/^[[:space:]]*$/d'`
    #pathOK="../${pathTemp}/${name_function}.yml"
    #echo $path_file_prepare | sed '/^[[:space:]]*$/d'
    #cat $pathOK | egrep "/aws/lambda/.*" | awk '{print $3}' | cut -c 13-18 | uniq
    #echo "check_and_execute_log_group_subscription 'temp/2022/file.txt' ${name_function}$i"
    #echo $name_function
done

#check_and_execute_log_group_subscription 'temp/condo-/file.txt' 'elkcondo' 'temp/2022-07-21-161051/elkcondo.yml' 'remove'
