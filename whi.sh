filename='temp/condo-/file.txt'
# n=1 
# while read line; do
# # reading each line
# novaLinha=`echo $line | sed 's/- log_group_name: //g'`
# echo $line
# #aws logs describe-subscription-filters --log-group-name $novaLinha | egrep logGroupName
# n=$((n+1))
# done < $filename

n=1
while read -r line;
do
# for read each line
echo "OS distribution line no. $n : $line"
n=$((n+1))
done < `cat $filename | sed '$a\'`