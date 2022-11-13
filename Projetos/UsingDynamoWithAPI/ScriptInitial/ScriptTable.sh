#!/bin/bash

echo "########### Creating table with global secondary index ###########"
        aws dynamodb --endpoint-url=http://localhost:4566 create-table \
            --table-name ExampleTable \
            --attribute-definitions \
                AttributeName=campo01Obj,AttributeType=S \
                AttributeName=campo2Hash,AttributeType=S \
            --key-schema \
                AttributeName=campo01Obj,KeyType=HASH \
                AttributeName=campo2Hash,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#00fld7j7l#5pir44f5c" }, "campo2Hash": { "S": "rd596ctsk#2022-10-21T17:42:34+00:00" }, "campo3cod_text": { "S": "zpmmya9b" }, "campo4tip": { "S": "people" },  "campo5nom": { "S": "Fulano de tal" } }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#mprlxg6r#5pir44f5c" }, "campo2Hash": { "S": "lbcdq0qoz#2022-10-21T17:42:35+00:00" }, "campo3cod_text": { "S": "tav9ji5or" }, "campo4tip": { "S": "people" }, "campo5nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#00fld7j7l#6uafwkkw8" }, "campo2Hash": { "S": "rxvx7hui6#2022-10-21T17:42:36+00:00" }, "campo3cod_text": { "S": "bpwojljcd" }, "campo4tip": { "S": "people" }, "campo5nom": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "qavsrds2#jbggjrapn#vppv7cp5v" }, "campo2Hash": { "S": "0ovwx0sdd#2022-10-21T17:42:37+00:00" }, "campo3cod_text": { "S": "oimstnti8" }, "campo4tip": { "S": "people" },  "campo5nom": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#00fld7j7l#5pir44f5c" }, "campo2Hash": { "S": "rd596ctsk#2022-10-21T17:42:38+00:00" }, "campo3cod_text": { "S": "f0bcjw7o9" }, "campo4tip": { "S": "people" },  "campo5nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#00fld7j7l#6uafwkkw8" }, "campo2Hash": { "S": "rd596ctsk#2022-10-21T17:42:38+00:00" }, "campo3cod_text": { "S": "f0bcjw7o9" }, "campo4tip": { "S": "people" },  "campo5nom": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "campo01Obj": { "S": "xmujr7ryw#00fld7j7l#6uafwkkw8" }, "campo2Hash": { "S": "rd596ctsk#2022-10-21T17:42:38+00:00" }, "campo3cod_text": { "S": "f0bcjw7o9" }, "campo4tip": { "S": "people" },  "campo5nom": { "S": "Fulano de tal" }}'


echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:4566 --table-name ExampleTable