#!/bin/bash
curl --header "Content-Type: application/json" \
--request POST \
--data '{"id": 3, "City": "", "Address": "Rua do Nunca", "LastName": "Escobar", "FirstName": "Nicolas"}' \
http://localhost:3000/testePost