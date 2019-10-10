CREDENTIAL_PATH=~/ddocuments/vault/aws/aws-brain.pem
if [ "$#" -ne 1 ]; then
    echo "Wrong paramters. Usage: ./get-logs.sh <servers.txt>"
    exit
fi
mapfile -t servers < $1
SAMPLER=${servers[0]}
SCANNERS=("${servers[@]:1}")

for i in "${!SCANNERS[@]}"; do 
    let "j=i+1"
    scp -o "StrictHostKeyChecking=no" -i $CREDENTIAL_PATH ubuntu@${SCANNERS[$i]}:/mnt/training.log ./training-$j.log &
done

scp -o "StrictHostKeyChecking=no" -i $CREDENTIAL_PATH ubuntu@$SAMPLER:/mnt/training.log ./training-sampler.log &
scp -o "StrictHostKeyChecking=no" -i $CREDENTIAL_PATH ubuntu@$SAMPLER:/mnt/testing.log ./testing-sampler.log &
scp -o "StrictHostKeyChecking=no" -i $CREDENTIAL_PATH ubuntu@$SAMPLER:/mnt/models/performance.csv ./performance-sampler.csv &

# scp -o "StrictHostKeyChecking=no" -r -i ~/ddocuments/vault/aws/aws-brain.pem ubuntu@$SAMPLER:/mnt/models/ ./models &

wait
echo "Done."

