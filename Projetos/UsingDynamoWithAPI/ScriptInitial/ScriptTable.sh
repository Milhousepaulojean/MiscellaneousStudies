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
        '{ "campo1Org": { "S": "xmujr7ryw#pfvwljuku#mha3ott6g" }, "campo2Unid": { "S": "00fld7j7l" }, "campo3Amigo": { "S": "5pir44f5c" }, "campo4Hash": { "S": "rd596ctsk" }, "campo5cod_text": { "S": "zpmmya9b" }, "campo6tip": { "S": "people" }, "campo7ori": { "S": "m" }, "campo8nom": { "S": "Fulano de tal" } }'

echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:4566 --table-name ExampleTable