# sam-app

Este projeto contém o código-fonte e os arquivos de suporte para uma aplicação serverless que você pode implantar com o SAM CLI. Ele inclui os seguintes arquivos e pastas:

- [`hello_world`]("hello_world") - Código para a função Lambda da aplicação.
- [`events`]("events") - Eventos de invocação que você pode usar para invocar a função.
- [`tests`]("tests") - Testes unitários para o código da aplicação.
- [`template.yaml`]("template.yaml") - Um modelo que define os recursos AWS da aplicação.

A aplicação usa vários recursos AWS, incluindo funções Lambda e uma API Gateway API. Esses recursos são definidos no arquivo [`template.yaml`]("template.yaml") deste projeto. Você pode atualizar o modelo para adicionar recursos AWS através do mesmo processo de implantação que atualiza o código da sua aplicação.

## Como implantar a aplicação de exemplo

O Serverless Application Model Command Line Interface (SAM CLI) é uma extensão do AWS CLI que adiciona funcionalidades para construir e testar aplicações Lambda. Ele usa Docker para executar suas funções em um ambiente Amazon Linux que corresponde ao Lambda. Ele também pode emular o ambiente de construção da sua aplicação e a API.

Para usar o SAM CLI, você precisa das seguintes ferramentas:

- SAM CLI - [Instale o SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
- [Python 3 instalado](https://www.python.org/downloads/)
- Docker - [Instale a edição comunitária do Docker](https://hub.docker.com/search/?type=edition&offering=community)

Para construir e implantar sua aplicação pela primeira vez, execute o seguinte no seu shell:

```bash
docker-compose up
```

E baixe o lauch.json e task.json para rodar a primeira versao.
Você pode encontrar a URL do Endpoint da sua API Gateway nos valores de saída exibidos após a implantação.

O SAM CLI instala as dependências definidas em [`hello_world/requirements.txt`]("hello_world/requirements.txt"), cria um pacote de implantação e o salva na pasta [`.aws-sam/build`](".aws-sam/build").

Teste uma única função invocando-a diretamente com um evento de teste. Um evento é um documento JSON que representa a entrada que a função recebe da fonte do evento. Os eventos de teste estão incluídos na pasta [`events`]("events") deste projeto.

Execute funções localmente e invoque-as com o comando `sam local invoke`.

```bash
sam-app$ sam local invoke HelloWorldFunction --event events/event.json
```

O SAM CLI também pode emular a API da sua aplicação. Use o `sam local start-api` para executar a API localmente na porta 3000.

```bash
sam-app$ sam local start-api
sam-app$ curl http://localhost:3000/
```

O SAM CLI lê o modelo da aplicação para determinar as rotas da API e as funções que elas invocam. A propriedade [`Events`](

## Limpeza

Para excluir a aplicação de exemplo que você criou, use o AWS CLI. Supondo que você usou o nome do seu projeto para o nome da stack, você pode executar o seguinte:

```bash
sam delete --stack-name "sam-app"
```

## Recursos

Veja o [guia do desenvolvedor AWS SAM](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html) para uma introdução à especificação SAM, ao SAM CLI e aos conceitos de aplicação serverless.

Em seguida, você pode usar o AWS Serverless Application Repository para implantar aplicativos prontos para uso que vão além dos exemplos de hello world e aprender como os autores desenvolveram suas aplicações: [Página principal do AWS Serverless Application Repository](https://aws.amazon.com/serverless/serverlessrepo/)
