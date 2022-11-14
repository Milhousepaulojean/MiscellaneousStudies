#!/bin/bash

echo "########### Creating table with global secondary index ###########"
        aws dynamodb --endpoint-url=http://localhost:4566 create-table \
            --table-name ExampleTable \
            --attribute-definitions \
                AttributeName=campo1Obj,AttributeType=S \
                AttributeName=campo3Hash,AttributeType=S \
            --key-schema \
                AttributeName=campo1Obj,KeyType=HASH \
                AttributeName=campo3Hash,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "5pir44f5c" }, "campo3Hash": { "S": "rd596ctsk#2022-10-21T17:42:34+00:00" }, "campo4cod_text": { "S": "zpmmya9b" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" } }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#mprlxg6r" }, "campo2Fri": { "S": "5pir44f5c" }, "campo3Hash": { "S": "lbcdq0qoz#2022-10-21T17:42:35+00:00" }, "campo4cod_text": { "S": "tav9ji5or" }, "campo5tip": { "S": "people" }, "campo6nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "6uafwkkw8" }, "campo3Hash": { "S": "rxvx7hui6#2022-10-21T17:42:36+00:00" }, "campo4cod_text": { "S": "bpwojljcd" }, "campo5tip": { "S": "people" }, "campo6nom": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "qavsrds2#jbggjrapn" }, "campo2Fri": { "S": "vppv7cp5v" }, "campo3Hash": { "S": "0ovwx0sdd#2022-10-21T17:42:37+00:00" }, "campo4cod_text": { "S": "oimstnti8" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "5pir44f5c" }, "campo3Hash": { "S": "rd596ctsk#2022-10-21T17:42:38+00:00" }, "campo4cod_text": { "S": "lgewauk6" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "6uafwkkw8" }, "campo3Hash": { "S": "rd596ctsk#2022-10-21T17:42:39+00:00" }, "campo4cod_text": { "S": "zzrsq2dts" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "6uafwkkw8" }, "campo3Hash": { "S": "rd596ctsk#2022-10-21T17:42:40+00:00" }, "campo4cod_text": { "S": "btw8v5jl" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo1Obj": { "S": "xmujr7ryw#00fld7j7l" }, "campo2Fri": { "S": "6fnpb62hx" }, "campo3Hash": { "S": "rd596ctsk#2022-10-21T17:42:41+00:00" }, "campo4cod_text": { "S": "35jhgwxcg" }, "campo5tip": { "S": "people" },  "campo6nom": { "S": "Fulano de tal" }}'


echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:4566 --table-name ExampleTable