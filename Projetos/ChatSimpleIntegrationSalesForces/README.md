# DOCUMENTAÇÃO SALESFORCE – CHAT

### Apresentação
Documentação para utilizar a API- Salesforce - Chat.
Descrição das etapas necessárias para utilizar a API:  iniciando a sessão do chat, envio e recebimento de mensagens.

### Autenticação
Não é preciso utilizar autenticação para fazer requisições a esta API.

### Error Codes
**400 – Bad Request**
A requisição não foi entendida, geralmente porque o Body contém um erro. 
> Ex: Falta de dados no header: Value do X-LIVEAGENT-API-VERSION não informado. 
> Ex: Falta de dados no body nos métodos POST.

**403 – Forbidden**
A requisição foi recusada, pois a sessão não é válida.
 > Ex: Falta informar o value gerado no GET no X-LIVEAGENT-AFFINITY e/ou no X-LIVEAGENT-SESSION-KEY.

**404 – Not Found**
Não foi possível encontrar o recurso solicitado, pois deve ter um erro na URL.

**405 – Method Not  Allowed**
O método especificado na Request Line não é permitido para o recurso especficado na URL. 

**500 – There was an error on the server and the request could not be completed**
Um erro ocorreu no servidor Live Agent, então a requisição não pôde ser concluída. Entre em contato com o suporte ao cliente. 

**503 – The server is unavailable to handle this request right now**
O affinity token foi alterado, pois a conexão com o servidor foi perdida. Faça uma requisição “ReconnectSession” para obter um novo affinity token, então faça uma requisição “ChasitorSessionData” para reestabelecer os dados do cliente na nova sessão. 

### EndPoints

#### 1. SessionId
-  **URL:** https://d.la4-c1-ph2.salesforceliveagent.com/chat/rest/System/SessionId
-  **METODO:** GET
- **HEADERS:**
X-LIVEAGENT-API-VERSION: 46
X-LIVEAGENT-AFFINITY: null
Content-Type: application/json
##### EXEMPLO DE RETORNO:
`
{
    "key": "29c64346-65b4-4214-912e-8e9391aecbaf!1570039675081!oLF8K6JmY4SDq89deoGlSHP5880=",
    "id": "29c64346-65b4-4214-912e-8e9391aecbaf",
    "clientPollTimeout": 40,
    "affinityToken": "98c41fa0"
}
`
##### FUNÇÃO: 
Cria a sessão do salesforce chat. Retorna um json com “key”, “id”, “clientPollTimeout”, “affinityToken”.

| FUNCIONALIDADES | |
| ------ | ------ |
| X-LIVEAGENT-API-VERSION: | Nº da versão da API Salesforce utilizada|
| X-LIVEAGENT-AFFINITY: | ID gerado pelo sistema e usado para identificar a sessão no servidor do Live Agent. O token é retornado no body do GET do SessionID. |
| Content-Type: | O formato que a aplicação está sendo passada. |
| "key": | Session Key da sessão. Gerado automaticamente pelo sistema pelo GET do SessionID. |
| "id":  | Session ID da sessão. Gerado automaticamente pelo sistema pelo GET do SessionID. |
| "clientPollTimeout": | Número de segundos para fazer uma requisição de Mensagem, antes de que o pooling de mensagens atinja o tempo limite e seja encerrado. |
| "affinityToken": | Token da sessão. Gerado automaticamente pelo sistema pelo GET do SessionID e que deve ser passado no header das futuras requisições. |

#### 2. ChasitorInit
-  **URL:** https://d.la4-c1-ph2.salesforceliveagent.com/chat/rest/Chasitor/ChasitorInit
-  **METODO:** POST
-  **HEADERS:**
X-LIVEAGENT-API-VERSION: 46
X-LIVEAGENT-SEQUENCE: 1
Content-Type: application/json
X-LIVEAGENT-AFFINITY: {{affinityToken}} 
X-LIVEAGENT-SESSION-KEY: {{key}}
##### BODY:
`
{
            "organizationId":"00D4T000000G87V",
            "deploymentId": "5724T000000CrUm",
            "buttonId": "5734T000000Crpa",
            "sessionId": {{id}},
            "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36",
            "language": "en-US",
            "screenResolution": "2560x1440",
            "visitorName": "Alef Bruno Rodrigues",
            "prechatDetails": [],
            "prechatEntities": [],
            "receiveQueueUpdates": true,
            "isPost": true
       } `

##### FUNÇÃO: 
Cria requisição de chat, conectando cliente ao atendente. Entra na fila dependendo do canal. O buttonId altera de acordo com o canal escolhido.

|FUNCIONALIDADES: | |
| ------ | ------ |
|X-LIVEAGENT-API-VERSION:  |  Nº da versão da API Salesforce utilizada. |
|X-LIVEAGENT-SEQUENCE: |  A sequência de mensagens enviadas ao servidor Live Agent para evitar o processamento de mensagens duplicadas. Este número deve ser aumentado (+1) a cada nova requisição. No método post é fixo e inicia do 1. |
|Content-Type: |  O formato que a aplicação está sendo passada |
| X-LIVEAGENT-AFFINITY: |  ID gerado pelo sistema e usado para identificar a sessão no servidor do Live Agent. O token é retornado no body do GET do SessionID. |
| X-LIVEAGENT-SESSION-KEY: |  ID único associado à sessão Live Agent. Essa chave não deve ser compartilhada, ou enviada em canais com pouca segurança já que permite o acesso de informações potencialmente confidenciais do chat. |
|*Todas as informações abaixo serão fornecidas pelo salesforce de acordo com as regras de negócio e estágio do projeto.*  |
|"organizationId": |   O ID do ambiente do Salesforce.  |
| "deploymentId": |   O ID do deployment de onde o chat foi configurado. |
| "buttonId": |  O ID do canal de onde o chat foi configurado. |
| "sessionId": | O ID da sessão Live Agent do cliente. |
| "userAgent": |  O navegador do cliente do chat. |
| "language": |   O idioma do cliente do chat. |
| "screenResolution": |  A resolução da tela do computador do cliente do chat. |
| "visitorName": |  O nome do cliente do chat. |
| "prechatDetails": |   A pré-informação fornecida pelo cliente/chatbot do chat. |
| "prechatEntities": | Configuração/ Pesquisa de registro referente ao atendimento/cliente. |
| "receiveQueueUpdates":  | Indica se o cliente do chat receberá atualizações (true), ou não (false) da posição da fila. |
| "isPost": |  Indica se a solicitação de chat foi feita corretamente por meio de uma solicitação POST (true), ou não (false). |

#### 3. Messages
-  **URL:** https://d.la4-c1-ph2.salesforceliveagent.com/chat/rest/System/Messages
-  **METODO:** GET
-  **HEADERS:**
X-LIVEAGENT-API-VERSION: 46
Content-Type: application/json
X-LIVEAGENT-AFFINITY: {{affinityToken}}
X-LIVEAGENT-SESSION-KEY: {{key}} 
##### EXEMPLOS DE RETORNO:
`
{"messages":[{"type":"ChatEnded", "message":{"attachedRecords":[],"reason":"agent"}}], "sequence":32, "offset":97391055} ;
{"messages":[{"type":"ChatRequestFail", "message":{"reason":"Unavailable","attachedRecords":[]}}], "sequence":2, "offset":97382097}
`
##### FUNÇÃO: 
Pooling (mantem a conexão do cliente com salesforce.Pode ser encerrado pelo lado do salesforce)

| FUNCIONALIDADES: | |
| ------ | ------ |
| X-LIVEAGENT-API-VERSION: | Nº da versão da API Salesforce utilizada. |
| Content-Type:  |  O formato que a aplicação está sendo passada. |
| X-LIVEAGENT-AFFINITY: |  ID gerado pelo sistema e usado para identificar a sessão no servidor do Live Agent. O token é retornado no body do GET do SessionID. |
| X-LIVEAGENT-SESSION-KEY: |  ID único associado à sessão Live Agent. Essa chave não deve ser compartilhada, ou enviada em canais com pouca segurança já que permite o acesso de informações potencialmente confidenciais do chat. |
|”messages”: | Essa requisição retorna um array de objetos que representa todos os eventos que ocorreram durante o chat. Essa requisição pode retornar diferentes subtipos. |
|"type": | Define o tipo de evento a ser retornado|
| - “AgentDisconnect” : | O agente foi desconectado do chat |
| - “AgentNotTyping”: | Indica que o agente não está digitando a mensagem para o cliente |
| - “AgentTyping”: | Indica que o agente está digitando a mensagem para o cliente |
| - “ChasitorSessionData”: | Quando ocorre o erro 503 é preciso solicitar um ReconnectSession para buscar um novo servidor. A sessão se mantém e os dados são restaurados. |
| - “ChatEnded”: | Informa que o chat foi finalizado pelo atendente. |
| - “ChatEstablished”: | Indica que o agente aceitou a solicitação do chat |
| - “ChatMessage”: | Informa que o agente enviou uma nova mensagem ao cliente do chat |
| - “ChatRequestFail”: | Indica que a solicitação de chat não foi bem sucedida | 
| - “ChatRequestSuccess”: | Indica que a solicitação de chat foi bem sucedida e redirecionada para um agente |
| - “ChatTransferred”: | Informa que o chat foi tranferido de um agente para outro |
| - “CustomEvent”: | Indica que um evento personalizado foi enviado de um agente para o cliente |
| -“NewVisitorBreadcrumb”: | Informa a url da página que o cliente está visualizando |
| - “QueueUpdate”: | Indica a nova posição do cliente na fila quando a posição muda |
| "connectionTimeout": | Informa o tempo ate a sessão ser desconectada |
| "estimatedWaitTime": | O tempo estimado de espera |
|"transcriptSaveEnabled": | Permite ao visitante gravar as mensagens do chat |
|"url": | O site do cliente que iniciou a sessão |
| "queuePosition": | Posição na fila do chat |
| "customDetails": | Dados personalizados do deployment de onde a requisição de chat foi iniciada |
|"visitorId": | O id que foi gerado automaticamente no get SessionId |
|"geoLocation":  | A localização baseada no IP do cliente. Retorna dados como: "organization", "region", "city", "countryName", "latitude", "countryCode", "longitude" |
| "type": | Define o tipo de evento a ser retornado |
|"QueueUpdate": | |Atualização da fila no Salesforce|
|"message": | Essa requisição retorna um array de objetos que representa todos os eventos que ocorreram durante o chat.|
|- "estimatedWaitTime": | O tempo estimado da fila no Salesforce |
| - "position": | A posição na fila do Salesforce |
|"sequence": | A sequência própria e gerada automaticamente no Salesforce. Não é a mesma sequência do chatmessage |

#### 4. ChatMessage
-  **URL:** https://d.la4-c1-ph2.salesforceliveagent.com/chat/rest/Chasitor/ChatMessage   
-  **METODO:** POST
-  **HEADERS:**
X-LIVEAGENT-API-VERSION: 46
X-LIVEAGENT-SEQUENCE: 4
Content-Type: application/json
X-LIVEAGENT-AFFINITY: {{affinityToken}}
X-LIVEAGENT-SESSION-KEY: {{key}}

##### EXEMPLO DE MENSAGEM:
>  {"text": "I have a question about my account."} 

##### FUNÇÃO: 
A mensagem enviada pelo cliente. É necessário alterar a sequence a cada mensagem.

| FUNCIONALIDADES: | |
| ------ | ------ |
| X-LIVEAGENT-API-VERSION: |  Nº da versão da API Salesforce utilizada. |
| X-LIVEAGENT-SEQUENCE: |  A sequência de mensagens enviadas ao servidor Live Agent para evitar o processamento de mensagens duplicadas. Este número deve ser aumentado (+1) a cada nova requisição. |
| Content-Type: |   O formato que a aplicação está sendo passada. |
| X-LIVEAGENT-AFFINITY: |  ID gerado pelo sistema e usado para identificar a sessão no servidor do Live Agent. O token é retornado no body do GET do SessionID. |
| X-LIVEAGENT-SESSION-KEY: |  ID único associado à sessão Live Agent. Essa chave não deve ser compartilhada, ou enviada em canais com pouca segurança já que permite o acesso de informações potencialmente confidenciais do chat. |
| "text": |  Mensagem enviada pelo cliente. |
