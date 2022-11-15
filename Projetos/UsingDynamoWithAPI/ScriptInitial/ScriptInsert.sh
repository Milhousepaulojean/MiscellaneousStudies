echo "########### Inserting test data into a table ###########"
aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "8F8C717A-BFFC-4BFA-8E04-605361410172" }, "cod_objt_cli": { "S": "32679660862#2022-10-21T17:42:34+00:00" }, "cod_objt_clsr_mens": { "S": "D2B5BB48-B9DB-48F6-83D8-BAFC8D429BA9" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" } }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#71A93CD9-5751-4446-861F-D6F77CFC3AE7" }, "cod_objt_aten": { "S": "8F8C717A-BFFC-4BFA-8E04-605361410172" }, "cod_objt_cli": { "S": "32679660863#2022-10-21T17:42:35+00:00" }, "cod_objt_clsr_mens": { "S": "7A60FEC0-39C1-4500-944F-3243001BFF51" }, "cod_objt_mens": { "S": "people" }, "nom_apel_remt": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "7658E568-6D0E-4B83-96E7-011D3C338394" }, "cod_objt_cli": { "S": "32679660864#2022-10-21T17:42:36+00:00" }, "cod_objt_clsr_mens": { "S": "8EAB8634-F46C-427B-B022-FF2383CA986F" }, "cod_objt_mens": { "S": "people" }, "nom_apel_remt": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#09CCD803-9635-4D34-99BF-C46E63DBCE61" }, "cod_objt_aten": { "S": "6FE695A0-29D9-49C8-BED6-F6DC6CFA4E4C" }, "cod_objt_cli": { "S": "32679660865#2022-10-21T17:42:37+00:00" }, "cod_objt_clsr_mens": { "S": "5E998895-6BCA-44F4-8703-EA2D9DE9322A" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "8F8C717A-BFFC-4BFA-8E04-605361410172" }, "cod_objt_cli": { "S": "32679660862#2022-10-21T17:42:38+00:00" }, "cod_objt_clsr_mens": { "S": "5B5D5543-C73A-4F5F-9173-3A6556F33D8D" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "1D78CCB3-F250-446F-8F71-C1B50F8FBFE8" }, "cod_objt_cli": { "S": "32679660862#2022-10-21T17:42:39+00:00" }, "cod_objt_clsr_mens": { "S": "8C8B5ACD-6F81-4087-A5EC-F57A1A5BD062" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" }}'


aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "1D78CCB3-F250-446F-8F71-C1B50F8FBFE8" }, "cod_objt_cli": { "S": "32679660862#2022-10-21T17:42:40+00:00" }, "cod_objt_clsr_mens": { "S": "D11126BD-C403-4BA6-B943-AA3F6C0C481D" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" }}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name ExampleTable  \
    --item \
        '{ "cod_objt_patc_mens": { "S": "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79#6FC300C4-1207-49A6-AE49-D584133C8624" }, "cod_objt_aten": { "S": "D78B109D-4BEB-4C79-8766-2A7E2AED51F2" }, "cod_objt_cli": { "S": "32679660862#2022-10-21T17:42:41+00:00" }, "cod_objt_clsr_mens": { "S": "A226F2C8-4D27-4174-9974-C8F29708C4FB" }, "cod_objt_mens": { "S": "people" },  "nom_apel_remt": { "S": "Fulano de tal" }}'

