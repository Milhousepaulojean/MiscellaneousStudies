#!/bin/bash

echo "########### Creating table with global secondary index ###########"
        aws dynamodb --endpoint-url=http://localhost:8000 create-table \
            --table-name ExampleTable \
            --attribute-definitions \
                AttributeName=nome,AttributeType=S \
                AttributeName=email,AttributeType=S \
            --key-schema \
                AttributeName=nome,KeyType=HASH \
                AttributeName=email,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva" }, "email": { "S": "ted@ted.com.br" }, "end": { "S": "rua das pintobeiras, 244" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva1" }, "email": { "S": "ted1@ted.com.br" }, "end": { "S": "rua das pintobeiras, 245" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva2" }, "email": { "S": "ted2@ted.com.br" }, "end": { "S": "rua das pintobeiras, 246" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva3" }, "email": { "S": "ted3@ted.com.br" }, "end": { "S": "rua das pintobeiras, 247" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva4" }, "email": { "S": "ted4@ted.com.br" }, "end": { "S": "rua das pintobeiras, 248" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Ted Silva5" }, "email": { "S": "ted5@ted.com.br" }, "end": { "S": "rua das pintobeiras, 249" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'

aws --endpoint-url=http://localhost:8000 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "nome": { "S": "Paulo J" }, "email": { "S": "pauloj@ted.com.br" }, "end": { "S": "rua das pintobeiras, 250" }, "cidade": { "S": "guarulhos" }, "estado": { "S": "sp" }}'


echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:8000 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:8000 --table-name ExampleTable