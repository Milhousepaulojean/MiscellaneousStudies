# Projeto Agenda GloboEsporte


Estarei aqui documentando os avanços por data do que foi feito durante o projeto:


# Features!

- Projeto Base
    -[comments] Etapa de construção do projeto de forma
    inicial como uma estrutura simples entre comunicação das camadas. Neste mesmo momento, codifiquei as camadas para comunicação e fluxo das informações. Assim como segue abaixo.
    - Criacao do Projeto Base @done (21/09/2020 22:06:38)
    - Criar estrutura com Camadas de Comunicação; @done (21/09/2020 22:35:23)
    - Criação de uma branch para desenvolvimento;
- Camada de Comunicação
    -[comments] Etapa de construção do projeto de evolução com as camadas em comunicação e arquivos de configuração.
    - Criar Rota para Agenda; @done (22/09/2020 00:20:21)
    - Criar aquirvo de configuração; @done (23/09/2020 00:27:57)
    - Estruturar o uso de camadas com imports; @done (23/09/2020 00:27:50)
    - Criar Consumo da API; @done (23/09/2020 00:27:43)
    - Ajustar PATHFILE no server.go @done (25/09/2020 05:20:05)
    - Adicionar URLAGENDA na chamada do rotasAgenda com import do Config com replace para data; @done (25/09/2020 05:20:16)
    - Alterar o nome do Method de ServicesAgenda para ServicesCall; @done (25/09/2020 05:20:38)

- Construção Front End
    -[comments] Etapa de construção Base para front, a tecnologia que melhor achei para o cenario foi Angular por sua capacidade em ser responsivo pelos devices

     - Planejar FrontEnd que chame API pela rota de Agenda; @done (23/09/2020 00:58:25)
     - Criar um projeto Angular @done (23/09/2020 10:05:01)
     - Criação da estrutura de services; @done (23/09/2020 10:06:34)
     - Construção da Camada de Services conectada ao Componente @done (23/09/2020 10:06:36)
     - Utilizar o BootStrap do https://globocom.github.io/bootstrap/index.html @done (27/09/2020 01:59:24)
     - Verificar data e hora atuais para envio do status dos jogos @done (27/09/2020 02:59:24); 
     - Desenvolvimento a estrutura estatica @done (27/09/2020 01:59:27)
     - Separar os Componente de navegaçao de data e Restante da pagina; @done (27/09/2020 01:59:28)
     - Criar estrutura estatica por campeonato de data e Campeonato @done (27/09/2020 01:59:29)
     - Criar Funcionalidade de data; @done (27/09/2020 01:59:32)
     - Looping com as informações dos Jogos Jogo -> fase -> edição -> campeonato @done (27/09/2020 01:59:36)
     
    
# Backlog
    - Criar solução para TimeWait que estejam a mais de 2 segundos; 
    - Tratar retornos 404 com mensagens amigaveis;
    - Desenvolvimento dos teste Unitarios com as camadas via FrontEnd/BackEnd das camadas BE;
    - Refactoring entre as camadas de FrontEnd e BackEnd com a retirada da logica e na passagem 
       das informações;
    - Mudanças com estados entre componentes de de header e Body;
    - Ajustes na vizualização dos componentes;

# Funcionamento
    - API:
        - O projeto BackEnd se encontra na pasta "BE", para funcionamento é preciso antes de tudo baixar todas as dependencias que foram adicionadas. 
        - Segue um exemplo do comando para funcionamento: "go get -u -v -f all"
        - Apos a instalação é preciso passar o seguinte comando para funcionamento das Apis: "go run ."
        - O projeto rodará sobre a porta configurada
    - FrontEnd:
        - O projeto FrontEnd se encontra na pasta "AgendaGEFrontEnd", para funcionamento é preciso antes de tudo baixar todas as dependencias que foram adicionadas. 
        - Segue um exemplo do comando para funcionamento: "npm i"
        - Apos a instalação é preciso passar o seguinte comando para funcionamento das Apis: "ng serve"
        - O projeto local estara em funcionamento na seguinte url "localhost:4200"



