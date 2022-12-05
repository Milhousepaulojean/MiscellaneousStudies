#!/bin/bash

echo "########### Creating table with global secondary index ###########"
        aws dynamodb --endpoint-url=http://localhost:4566 create-table \
            --table-name ExampleTablePessoa \
            --attribute-definitions \
                AttributeName=nome,AttributeType=S \
                AttributeName=email,AttributeType=S \
            --key-schema \
                AttributeName=nome,KeyType=HASH \
                AttributeName=email,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

        aws dynamodb --endpoint-url=http://localhost:4566 create-table \
            --table-name ExampleTableLogradouro \
            --attribute-definitions \
                AttributeName=endereco,AttributeType=S \
                AttributeName=estado,AttributeType=S \
            --key-schema \
                AttributeName=endereco,KeyType=HASH \
                AttributeName=estado,KeyType=RANGE \
        --provisioned-throughput \
                ReadCapacityUnits=10,WriteCapacityUnits=5

echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTablePessoa  \
    --item \
        '{ "endereco": { "S": "Rua Sem fim, 000 - Terra do nunca" }, "estado": { "S": "paulo@silva.com" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTableLogradouro  \
    --item \
        '{ "nome": { "S": "Paulo Silva" }, "email": { "S": "paulo@silva.com" }}'

echo "########### Describing a status ###########"
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name ExampleTable | grep TableStatus

echo "########### select info  ###########"
aws dynamodb scan --endpoint-url=http://localhost:4566 --table-name ExampleTable