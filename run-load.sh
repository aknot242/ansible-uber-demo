OUT_FILE="output.har"

# remove output file if exists
rm -f $OUT_FILE

sudo docker run -it -e "BASE_URL=$1" -e "OUT_FILE=$OUT_FILE" -v $(pwd):/tmp --entrypoint /bin/ash aknot242/har-replay '/tmp/transform-har.sh'

i=1
while [[ $i -le $2 ]]
do
    echo "Run iteration $i"
    sudo docker run -it -v $(pwd):/tmp aknot242/har-replay node main.js -f /tmp/$OUT_FILE
    ((i = i + 1))
done
