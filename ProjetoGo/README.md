## Paulo Jean
**Globo.com: coding challenge**

====================
#### Considerações Gerais
Você deverá usar este repositório como o repo principal do projeto, i.e., todos os seus commits devem estar registrados aqui, pois queremos ver como você trabalha.

Devemos conseguir rodar seu código em um Mac OS X OU no Ubuntu;

Devemos ser capazes de executar o seu código no nosso ambiente local ou em uma VM ou máquina limpa com os seguintes comandos, ou algo similar:

```bash
git clone seu-repositorio
cd seu-repositorio
./configure # (ou algo similar)
make run # (ou algo similar)
```

Esses comandos devem ser o suficiente para configurar uma nova VM e rodar o seu programa. Considere que o meu usuário não é root, porém tem permissão de sudo. Podes considerar que temos instalado no meu sistema: Java, Python, Ruby ou Go. Qualquer outra dependência que precisarmos você deverá prover.

**Registre tudo**: testes que forem executados, ideias que gostaria de implementar se tivesse mais tempo (explique como você as resolveria, se houvesse tempo), decisões que forem tomadas e seus porquês, arquiteturas que forem testadas e os motivos de terem sido modificadas ou abandonadas. Crie um arquivo COMMENTS.md ou HISTORY.md no repositório para registrar essas reflexões e decisões.

=====================
#### O Desafio: Agenda de Jogos GE

Desenvolva um BFF que será consumido pelos clients **apenas** para montar a página abaixo:

![Agenda GE](agenda-tela.png?raw=true)

Na raiz do projeto, você encontrará o serviço `esportes-api`. Essa API possui 3 rotas que te fornecerão todos os dados necessários referentes a time, campeonatos e jogos de uma data. São elas:
1. `GET /esportes/futebol/modalidades/futebol_de_campo/categorias/profissional/data/<DATA>/jogos/` - Retorna todas as informações e referências dos jogos da data pedida. Usar o formato `YYYY-MM-DD`. Considere que a API só entrega jogos do ano de 2019. Se não houver jogo na data solicitada, a API retornará 404.
2. `GET /equipes/<ID>` - Retorna todas as informações e referências da equipe. Se não existir uma equipe com o id informado, a API retornará 404.
3. `GET /esportes/futebol/modalidades/futebol_de_campo/categorias/profissional/campeonato/<ID>` - Retorna todas as informações e referências do campeonato.Se não existir um campeonato com o id informado, a API retornará 404.

#### Considerações sobre a `esportes-api`:
1. Você **NÃO DEVE** alterar nenhum código dessa API. Sua relação com essa API é apenas de cliente.
2. Para subir o serviço basta executar o seguinte comando:
`cd esportes-api && yarn && yarn start` (ou npm).
A API pode ser acessada via `127.0.0.1:8080`
3. A API retorna sempre uma estrutura de payload que contém `resultados` e `referencias`. As referências são complementos dos dados de resultado e podem ser muito úteis.
4. Todo jogo pertence a uma fase de um campeonato que, por sua vez, pertence a uma edição de campeonato que, finalmente, pertence a um campeonato. É correto considerar o seguinte fluxo de relação/navegação entre jogos e campeonatos:
`Jogo -> fase -> edição -> campeonato`.
Ex: `Jogo 123 é da Fase Semifinal da Edição Libertadores 2019 do Campeonato Taça Libertadores`
5. Essa API não foi arquitetada para receber uma alta carga de requests por segundo e a API que você irá construir será chamada diretamente pelo frontend por uma página que recebe em média 1k requests por segundo.
6. Sobrecarregar a `esportes-api` pode resultar na sua queda ocasionando errors para outros clientes desta API o que pode gerar um problema em todo portal do GE.
7. As rotas da `esportes-api` podem apresentar lentidões resultando em tempos de resposta de 2 segundos ou mais.
8. A API só possui jogos cadastrados para datas do ano de 2019.


============================
#### Requisitos
1. Sua API deverá fornecer uma rota onde os clients conseguem pegar todas as informações necessárias pra montar a agenda de um dia.
Ex: GET `/agenda/2019-08-19` -> o payload retornado deve ser suficiente pra montar uma página como a da imagem acima.
2. Os front-ends deverão ser capazes de receber todos os dados necessários pra montar a página fazendo apenas um request pra sua API.
3. Múltiplos front-ends (apps iOS e Android e a página Web) serão clientes da sua API e terão telas extremamente parecidas e com as mesmas regras de negócio. Considere abstrações na sua API que evitem dos clients precisarem codar a mesma regra de negócio nas 3 plataformas por exemplo.
4. Jogos em um dia podem variar entre diferentes momentos (Já ocorreram, estão ocorrendo ou irão ocorrer). As equipes de front-end sinalizaram que seria legal conseguir saber de uma maneira simples os jogos de cada momento. Considere que um jogo leva 2 horas para acabar. 
5. A página de agenda, somando as 3 plataformas, recebe normalmente um grande número de acessos num curto espaço de tempo. Seria legal ter um teste garantindo que a API está pronta pra receber essa carga, e por razões práticas, podemos considerar 1000 requests/seg como baseline de performance desse teste.  
6. Considere que o seu BFF será utilizado única e exclusivamente por essa feature de Agenda porém por pelo menos 3 front-ends diferentes. Tornar a vida dos seus clients mais fácil é uma boa idéia :)
_*(Opcional)*_ Conforme dito anteriormente, você tem liberdade de definir a linguagem de programação que quiser. Porém, **apenas caso se sinta confortável**, usar Golang pode ser uma boa ideia :)
_*(Opcional|Bônus)*_ Pode existir um cenário onde a `esportes-api` comece a responder muitos errors em um intervalo de tempo. Pode ser uma boa ideia pensar em algum mecanismo para evitar de onerarmos ainda mais o serviço.

O projeto deve estar "pronto para produção" em termos de:

1. Formatação e estruturação do código;
2. Performance;
3. Segurança.

Envie as instruções necessárias para rodar o projeto localmente, incluindo todas as dependências. Devemos ser capazes de executar o seu código em uma VM ou máquina limpa com os seguintes comandos, ou algo similar:

===============================================
#### O que será avaliado na sua solução?

1. As funcionalidades listadas anteriormente devem estar presentes na sua solução.
2. Seu código será observado por uma equipe de desenvolvedores que avaliarão a simplicidade e clareza da solução, a arquitetura, documentação, estilo de código, testes automatizados, o design e a implementação do código.

=============
#### Dicas

- Você pode usar ferramentas e bibliotecas open source, mas documente as decisões e os porquês. Considere que queremos entender a forma como você resolveria o problema, portanto, terceirizar para libs suas regras de negócio pode não ser uma boa ideia;
- Automatize tudo que for possível;
- Se sentir que poderia ter feito algo de uma forma melhor porém o tempo não permitiu, fique a vontade para criar um arquivo `.md` e compartilhar essas ideias;
- Em caso de dúvidas, pergunte.
