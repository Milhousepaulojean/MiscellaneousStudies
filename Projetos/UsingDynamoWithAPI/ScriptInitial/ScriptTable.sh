#!/bin/bash

echo "########### Creating table with global secondary index ###########"
        aws dynamodb --endpoint-url=http://localhost:4566 create-table \
            --table-name ExampleTable \
            --attribute-definitions \
                AttributeName=campo1Org,AttributeType=S \
                AttributeName=campo2Unid,AttributeType=S \
            --key-schema \
                AttributeName=campo1Org,KeyType=HASH \
                AttributeName=campo2Unid,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Org": { "S": "xmujr7ryw" }, "campo2Unid": { "S": "00fld7j7l" }, "campo3Amigo": { "S": "5pir44f5c" }, "campo4Hash": { "S": "rd596ctsk" }, "campo5cod_text": { "S": "zpmmya9b" }, "campo6tip": { "S": "people" }, "campo7ori": { "S": "m" }, "campo8nom": { "S": "Fulano de tal" } }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Org": { "S": "xmujr7ryw" }, "campo2Unid": { "S": "mprlxg6r" }, "campo3Amigo": { "S": "5pir44f5c" }, "campo4Hash": { "S": "lbcdq0qoz" }, "campo5cod_text": { "S": "tav9ji5or" }, "campo6tip": { "S": "people" }, "campo7ori": { "S": "m" }, "campo8nom": { "S": "Fulano de tal" } }'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Org": { "S": "xmujr7ryw" }, "campo2Unid": { "S": "00fld7j7l" }, "campo3Amigo": { "S": "6uafwkkw8" }, "campo4Hash": { "S": "rxvx7hui6" }, "campo5cod_text": { "S": "bpwojljcd" }, "campo6tip": { "S": "people" }, "campo7ori": { "S": "m" }, "campo8nom": { "S": "Fulano de tal" } }'



aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Org": { "S": "qavsrds2" }, "campo2Unid": { "S": "jbggjrapn" }, "campo3Amigo": { "S": "vppv7cp5v" }, "campo4Hash": { "S": "0ovwx0sdd" }, "campo5cod_text": { "S": "oimstnti8" }, "campo6tip": { "S": "people" }, "campo7ori": { "S": "m" }, "campo8nom": { "S": "Fulano de tal" } }'


echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:4566 --table-name ExampleTable