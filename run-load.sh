#!/bin/bash

docker run -it -e "HOST=$1" -v $(pwd):/tmp --entrypoint /bin/ash har-replay '/tmp/transform-har.sh'

i=1
while [[ $i -le $2 ]]
do
    echo "Run iteration $i"
    docker run -it -v $(pwd):/tmp aknot242/har-replay node main.js -f /tmp/output.har
    ((i = i + 1))
done
