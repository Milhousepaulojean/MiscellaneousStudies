# Plano de Desenvolvimento Individual (PDI)

## Objetivo de Carreira

- **Transição de Cargo:**
  - Passar de Engenheiro de Software para Arquiteto de Software.

## Objetivos de Carreira

### Curto Prazo (6-12 meses)

- **Aprendizagem e Certificação:**
  - Concluir cursos de arquitetura de software.
  - Obter certificações relevantes.
- **Experiência Prática:**
  - Participar em projetos que envolvam decisões de arquitetura.
  - Trabalhar próximo aos arquitetos de software para entender melhor o papel.
- **Desenvolvimento de Soft Skills:**
  - Melhorar habilidades de comunicação e apresentação.
  - Desenvolver habilidades de liderança e gestão de projetos.

### Médio Prazo (1-3 anos)

- **Papel de Liderança:**
  - Assumir um papel de liderança em projetos de software.
  - Tornar-se um recurso chave para decisões de arquitetura dentro da equipe.
- **Reconhecimento Profissional:**
  - Tornar-se um arquiteto de software reconhecido na empresa.

### Longo Prazo (3-5 anos)

- **Especialização:**
  - Tornar-se um especialista em arquitetura de software com reconhecimento no mercado.
  - Contribuir para a comunidade de tecnologia através de mentorias, blogs ou palestras.
- **Inovação:**
  - Participar em projetos/Comunidaes de inovação e transformação digital.

## Habilidades a Desenvolver

### Habilidades Técnicas

- **Padrões de Arquitetura:**
  - Domínio de padrões de arquitetura (Microservices, Serverless, etc.).
- **Linguagens de Programação:**
  - Conhecimento avançado em linguagens de programação relevantes (Java, Python, etc.).
- **Ferramentas de DevOps:**
  - Proficiência em ferramentas como Docker, Kubernetes, CI/CD.
- **Design de Sistemas:**
  - Aumentar meu leque de conhecimento ao projetar sistemas escaláveis e resilientes.

### Habilidades Interpessoais

- **Comunicação:**
  - Desenvolver comunicação eficaz para explicar decisões técnicas a diferentes públicos.
- **Liderança:**
  - Melhorar habilidades de liderança e gestão de equipes.
- **Negociação:**
  - Aprender técnicas de negociação e resolução de conflitos.

### Habilidades Adicionais

- **Gerenciamento de Tempo:**
  - Eficiência no gerenciamento de tempo e priorização de tarefas.
- **Pensamento Crítico:**
  - Desenvolver habilidades de pensamento crítico e resolução de problemas.
- **Metodologias Ágeis:**
  - Prática em metodologias ágeis (Scrum, Kanban).
- **Análises e Estatísticas:**
  - Conhecimento em análises e estatísticas aplicadas.
  - Implementação e interpretação de testes A/B.

# Padrões de Projeto

## Padrões Criacionais

1. **[Factory Method](https://refactoring.guru/design-patterns/factory-method)**

   - Define uma interface para criar um objeto, mas permite que as subclasses alterem o tipo de objeto que será criado.

2. **[Abstract Factory](https://refactoring.guru/design-patterns/abstract-factory)**

   - Fornece uma interface para criar famílias de objetos relacionados ou dependentes sem especificar suas classes concretas.

3. **[Builder](https://refactoring.guru/design-patterns/builder)**

   - Separa a construção de um objeto complexo da sua representação, permitindo a criação passo a passo.

4. **[Prototype](https://refactoring.guru/design-patterns/prototype)**

   - Permite a criação de novos objetos copiando instâncias existentes, evitando a complexidade de criar instâncias de forma manual.

5. **[Singleton](https://refactoring.guru/design-patterns/singleton)**
   - Garante que uma classe tenha apenas uma instância e fornece um ponto global de acesso a ela.

## Padrões Estruturais

1. **[Adapter](https://refactoring.guru/design-patterns/adapter)**

   - Permite que interfaces incompatíveis trabalhem juntas convertendo a interface de uma classe em outra interface esperada pelos clientes.

2. **[Bridge](https://refactoring.guru/design-patterns/bridge)**

   - Desacopla uma abstração da sua implementação, permitindo que ambas variem independentemente.

3. **[Composite](https://refactoring.guru/design-patterns/composite)**

   - Compõe objetos em estruturas de árvore para representar hierarquias parte-todo. Permite que os clientes tratem objetos individuais e composições de forma uniforme.

4. **[Decorator](https://refactoring.guru/design-patterns/decorator)**

   - Anexa responsabilidades adicionais a um objeto dinamicamente. Os decoradores fornecem uma alternativa flexível ao uso de subclasses para estender funcionalidades.

5. **[Facade](https://refactoring.guru/design-patterns/facade)**

   - Fornece uma interface simplificada para um subsistema complexo.

6. **[Flyweight](https://refactoring.guru/design-patterns/flyweight)**

   - Usa o compartilhamento para suportar eficientemente grandes quantidades de objetos de grão fino.

7. **[Proxy](https://refactoring.guru/design-patterns/proxy)**
   - Fornece um substituto ou ponto de acesso para outro objeto para controlar o acesso a ele.

## Padrões Comportamentais

1. **[Chain of Responsibility](https://refactoring.guru/design-patterns/chain-of-responsibility)**

   - Evita o acoplamento do remetente de uma solicitação ao seu receptor ao dar a mais de um objeto a chance de tratar a solicitação.

2. **[Command](https://refactoring.guru/design-patterns/command)**

   - Encapsula uma solicitação como um objeto, permitindo parametrizar clientes com diferentes solicitações, enfileirar ou registrar solicitações, e suportar operações reversíveis.

3. **[Iterator](https://refactoring.guru/design-patterns/iterator)**

   - Fornece uma maneira de acessar sequencialmente os elementos de um objeto agregado sem expor sua representação subjacente.

4. **[Mediator](https://refactoring.guru/design-patterns/mediator)**

   - Define um objeto que encapsula como um conjunto de objetos interage, promovendo um acoplamento fraco.

5. **[Memento](https://refactoring.guru/design-patterns/memento)**

   - Sem violar o encapsulamento, captura e externaliza o estado interno de um objeto para que o objeto possa ser restaurado a esse estado mais tarde.

6. **[Observer](https://refactoring.guru/design-patterns/observer)**

   - Define uma dependência um-para-muitos entre objetos para que quando um objeto mudar de estado, todos os seus dependentes sejam notificados e atualizados automaticamente.

7. **[State](https://refactoring.guru/design-patterns/state)**

   - Permite que um objeto altere seu comportamento quando seu estado interno muda. O objeto parecerá ter mudado de classe.

8. **[Strategy](https://refactoring.guru/design-patterns/strategy)**

   - Define uma família de algoritmos, encapsula cada um deles e os torna intercambiáveis. Permite que o algoritmo varie independentemente dos clientes que o utilizam.

9. **[Template Method](https://refactoring.guru/design-patterns/template-method)**

   - Define o esqueleto de um algoritmo em uma operação, diferindo alguns passos para as subclasses. Permite que as subclasses redefinam certos passos de um algoritmo sem mudar a estrutura do mesmo.

10. **[Visitor](https://refactoring.guru/design-patterns/visitor)**
    - Representa uma operação a ser realizada nos elementos de uma estrutura de objeto. Permite que uma nova operação seja definida sem mudar as classes dos elementos sobre os quais opera.

## Leituras Recomendadas

- **Mergulho nos Padrões de Projeto**
- Arquitetura Limpa. O Guia do Artesao para Estrutura e Design de Software

  - Introdução

    - A História das Disciplinas de Software: Explora a evolução da engenharia de software e a importância da arquitetura.
    - O Que é Arquitetura?: Define o que significa arquitetura de software e sua importância.

  - Paradigmas de Programação

    - Paradigma Estruturado
    - Paradigma Orientado a Objetos
    - Paradigma Funcional

  - Princípios Sólidos

    - SRP (Single Responsibility Principle): Princípio da responsabilidade única.
    - OCP (Open-Closed Principle): Princípio do aberto-fechado.
    - LSP (Liskov Substitution Principle): Princípio da substituição de Liskov.
    - ISP (Interface Segregation Principle): Princípio da segregação de interfaces.
    - DIP (Dependency Inversion Principle): Princípio da inversão de dependência.

  - Componentes de Design

    - Componentes e Coesão: Como criar componentes coesos.
    - Componentes e Acoplamento: Como minimizar o acoplamento entre componentes.
    - Componentes e Ciclos: Evitando dependências cíclicas entre componentes.

  - Arquitetura

    - O Que é Arquitetura de Software?
    - Regras de Dependência
    - Arquitetura Limpa
    - Limites Arquiteturais: Definindo e respeitando limites claros na arquitetura.
    - As Regras da Arquitetura Limpa

  - Detalhes

    - Estratégias de Banco de Dados: Separar a lógica do banco de dados da lógica de negócios.
    - Web é um Detalhe
    - Frameworks são Detalhes
    - Gerenciamento de Sessão
    - Teste Arquitetural

  - Conclusão

  - Caminho para a Maestria: Disciplina e prática para se tornar um arquiteto de software eficaz.

## Artigos

- https://www.oreilly.com/library/view/understanding-experimentation-platforms/9781492038139/

- https://engineering.atspotify.com/2023/08/coming-soon-confidence-an-experimentation-platform-from-spotify/

- https://confidence.spotify.com/blog/ab-tests-and-rollouts

- https://www.microsoft.com/en-us/research/group/experimentation-platform-exp/articles/stedii-properties-of-a-good-metric/

- https://alexbretas11.medium.com/pdi-uma-boa-ideia-mal-executada-1c3399187932

- https://franklincovey.com.br/blog/autoavaliacao/

- https://basecase.vc/blog/headless-bi
- https://engineering.atspotify.com/2020/10/spotifys-new-experimentation-platform-part-1/

## Cursos Recomendados

### Plataformas Online

- **Udemy:**

- **FullCyle:**

- **Degreed:**

- **idiomus - Ingles:**

### Certificações

1. **Foundational**

   - [AWS Certified Cloud Practitioner](https://aws.amazon.com/certification/certified-cloud-practitioner/)

2. **Associate**

   - [AWS Certified Solutions Architect – Associate](https://aws.amazon.com/certification/certified-solutions-architect-associate/)
   - [AWS Certified Developer – Associate](https://aws.amazon.com/certification/certified-developer-associate/)
   - [AWS Certified SysOps Administrator – Associate](https://aws.amazon.com/certification/certified-sysops-admin-associate/)

3. **Professional**

   - [AWS Certified Solutions Architect – Professional](https://aws.amazon.com/certification/certified-solutions-architect-professional/)
   - [AWS Certified DevOps Engineer – Professional](https://aws.amazon.com/certification/certified-devops-engineer-professional/)

4. **Specialty**
   - [AWS Certified Advanced Networking – Specialty](https://aws.amazon.com/certification/certified-advanced-networking-specialty/)
   - [AWS Certified Data Analytics – Specialty](https://aws.amazon.com/certification/certified-data-analytics-specialty/)
   - [AWS Certified Security – Specialty](https://aws.amazon.com/certification/certified-security-specialty/)
   - [AWS Certified Machine Learning – Specialty](https://aws.amazon.com/certification/certified-machine-learning-specialty/)
   - [AWS Certified Database – Specialty](https://aws.amazon.com/certification/certified-database-specialty/)
   - [AWS Certified SAP on AWS – Specialty](https://aws.amazon.com/certification/certified-sap-specialty/)

## Plano de Ação

### Mensal

- **Revisão e Metas:**
  - Revisar e atualizar o PDI conforme necessário.
  - Definir metas específicas e revisá-las ao final de cada mês.
- **Desenvolvimento Contínuo:**
  - Participar de pelo menos um webinar ou workshop online.

### Trimestral

- **Educação e Autoavaliação:**
  - Realizar um curso online ou módulo de certificação.
  - Ler pelo menos um livro recomendados.
  - Fazer uma autoavaliação das habilidades desenvolvidas.

### Anual

- **Certificações e Participação:**
  - Concluir uma certificação relevante.
  - Para cada Estudo um link com estudos no Git
  - Revisar e refletir sobre os objetivos de carreira e ajustar conforme necessário.
