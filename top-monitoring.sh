# !/bin/bash


read -p "Plz provide the CSV file name to store the output e.g. node1.csv : " filename

echo "Monitoring the command for 1 hour"

declare -a services=("iotc-repo" "iotc-distribution" "console" "alert" "aggregator" "metricque" "metricingest" "communicator" "lcm" "notifications" "devicemgmt" "iam" "kapacitor" "mongod.conf" "influxd-meta" "influxdb.conf" "mongos.conf" "mongod-cs.conf")


declare -a pidArr=()

for j in ${services[@]}
do
	pid=`ps -ef | grep "$j"|grep -v grep | awk '{ print $2 }'`
	echo $pid "-" $j 
	pidArr+=($pid)
done
echo `(IFS=,; echo "${pidArr[*]}")`


for (( count = 1; count <= 3600000; count++ )) 
do
	echo top -b -n1 -p `(IFS=,; echo "${pidArr[*]}")`
	COLUMNS=1000 top -b -n1 -p `(IFS=,; echo "${pidArr[*]}")` > temp_top.txt
        
	for i in "${services[@]}"
        do 
       	echo "$i,`cat temp_top.txt | grep $i | grep -v grep | awk '{ print $7}'`,`cat temp_top.txt | grep "$i" | grep -v grep | awk '{ print $8}'`" >> $filename  
        done
	
        #sleep 1s
	rm temp_top.txt
done

