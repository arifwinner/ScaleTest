declare -a services=(iotc-metricquery iotc-aggregator iotc-devicemgmt iotc-notifications iotc-lcm iotc-communicator iotc-metricingest iotc-repo iotc-alert iotc-iam)
if [[ ! -d dumps ]] ; then
mkdir dumps
else 
rm -rf dumps/*
fi
for i in "${services[@]}" ; do
docker cp dumps_builder.sh $i:/home/
docker exec -it $i /home/dumps_builder.sh
docker cp $i:/tmp/test ./dumps/$i
done
