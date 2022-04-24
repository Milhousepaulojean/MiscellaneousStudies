<img src="https://cdn.icon-icons.com/icons2/2107/PNG/512/file_type_typescript_official_icon_130107.png" width=100 heigth=100 alt="TypeScript" />

# ![Typescript](https://www.typescriptlang.org/)
TypeScript é uma linguagem para JavaScript em escala de aplicativo. O TypeScript adiciona tipos opcionais ao JavaScript que suportam ferramentas para aplicativos JavaScript em larga escala para qualquer navegador, para qualquer host, em qualquer sistema operacional. O TypeScript compila para JavaScript legível e baseado em padrões. Experimente no playground e mantenha-se atualizado através do nosso blog e conta do Twitter.

# Explicacao

O TypeScript foi criado principalmente para resolver dois problemas:

Fornecer aos desenvolvedores de JavaScript um sistema de tipagem.

Fornecer aos desenvolvedores de JavaScript a capacidade de utilizar recursos mais recentes do JavaScript que ainda não são suportados browsers, Node.js e afins.

# Tipos
Os 3 tipos básicos mais conhecidos são:

boolean: valores true ou false;
const isValid: boolean = true;
number: valores numéricos;
const actualYear: number = 2020;
string: valores textuais;
const aula: string = "Iniciando com Typescript";
Além dessas, temos outras tipagens básicas não muito convencionais:

any: aceita qualquer valor. Utilizado quando não queremos fazer a checagem do tipo;

void: é basicamente o oposto de any, utilizado principalmente para demarcar quando não queremos retornar valores de uma função (mesmo assim, ao utilizar void a função irá retornar undefined, explicitamente ou implicitamente);

null: aceita valores do tipo null;

undefined: aceita valores do tipo undefined;

never: não aceita nenhum tipo, utilizada principalmente para funções que nunca devem retornar algo, como loops infinitos ou excessões.

Vejamos alguns recursos do Typescript para expandir as tipagens do nosso código:

# Arrays
Temos duas formas principais de declará-los: adicionando [] ao final do tipo ou utilizando o generic Array<T>. Exemplo:

const users: string[] = ["John", "Doe", "Nati", "Lucas", "Phil"];

const users: Array<string> = ["John", "Doe", "Nati", "Lucas", "Phil"];
Tuples
Utilizado quando queremos trabalhar com arrays que sabemos exatamente quantos elementos ele terá, mas que não serão necessariamente do mesmo tipo. Exemplo:

const tupleSample: [string, boolean] = ["Algo de errado?", true]
Enums
Utilizado quando queremos dar um nome mais amigável a um conjunto de valores. Exemplo:

enum Techs {
	Node, 
	Typescript, 
	TypeORM,
  Docker
};
const curse: Techs = Techs.Node;
console.log(curse) // Irá printar o valor 0

# Objetos
Apesar de ser possível descrever um objeto utilizando simplesmente o object, não é recomendado pois dessa forma não conseguimos definir os campos, a sua estrutura.

# Interfaces
É aí que as interfaces entram e nos ajudam (bastante). Exemplo:

interface EveryExampleInOne {
	str: string;
	num: number;
	bool: boolean;
	func(arg1: string): void;
	arr: string[];
}

 
Onde temos uma interface EveryExampleInOne que possui 5 propriedades. Elas possuem, respectivamente, os seguintes tipos:

string
number
boolean
Função que recebe um argumento do tipo string e tem como retorno o tipo void
Array de strings
Optional Properties
Uma possibilidade interessante nas interfaces é definir uma propriedade como opcional. Exemplo:

interface Curse {
	name: string;
	duration?: string;
}

 
Onde temos que o nome do curso é obrigatório, mas a duração é opcional.

# Dynamic Properties
Além disso, outro caso interessante é quando além das propriedades que declaramos, queremos deixar em aberto que novas propriedades de um certo tipo sejam adicionadas. Exemplo:

```sh
interface User {
	name: string;
	email: string;
	[propName: string]: string;
}
```
 
Onde temos uma interface User na qual, além das 2 propriedades que definimos, deixamos em aberto a possibilidade de N novas propriedades de nome (propName) string cujo valor também é do tipo string. Poderíamos implementar algo do tipo:

```sh
const john: User = {
	name: "John Doe",
	email: "johndoe@server.com",
	nickname: "johndoe",
	address: "Street One"
}
```

# Readonly Properties
Além disso, podemos também definir que uma propriedade é apenas para leitura, pode atribuir um valor a ela apenas uma vez. Segue um exemplo:

```sh
interface Alunos {
	readonly aprovado: boolean;
}

let classe: Alunos = { aprovado: false }
classe.aprovado = true // erro
```

# Implements
Utilizando conceitos já comuns em linguagens tipadas como C# e Java, temos a possibilidade de reforçar que uma classe (ou uma função) atenda os critérios definidos em uma interface. Exemplo:

```sh
interface BalanceInterface {
  increment(income: number): void;
  decrement(outcome: number): void;
}

class Balance implements BalanceInterface {
  private balance: number;

  constructor() {
    this.balance = 0;
  }

  increment(income: number): void {
    this.balance += income;
  }

  decrement(outcome: number): void {
    this.balance -= outcome;
  }
}
```
 
Lembrando que ao utilizar o implements para que a interface force a classe a seguir os padrões impostos, só conseguimos referenciar o lado público (public) da classe.

# Extends
Outro conceito importante já apresentado nessas linguagens é a possibilidade de uma interface herdar propriedades de outra interface. Exemplo:

```sh
interface Aircraft {
    speed: number;
}

interface Fighter extends Aircraft {
    hasMissiles: boolean;
		missiles?: number;
}

const f22: Fighter = {
	  speed: 2000,
	  hasMissiles: true,
		missiles: 4,
};
```

# Union Types
Em alguns casos, queremos que uma variável/propriedade aceite mais de um tipo. Para esses casos, utilizamos os Union Types. Exemplo:

```sh
let age: number | string = 30;
age = "30"; 
age = false; // erro
```

# Generics
Vimos diversas formas até agora de como realizar a tipagem com Typescript, até mesmo em casos mais complexos como funções e objetos. Mas e se, por exemplo, não soubermos, durante o desenvolvimento, qual tipo o argumento e o retorno de uma função devem receber? Para isso utilizamos os Generics. Exemplo:

```sh
const users: Array<string> = ["John", "Doe", "Nati", "Lucas", "Phil"];
```
 
Nesse exemplo utilizamos um generic do próprio Typescript, o Array, em que o tipo informado dentro de <> representa o tipo dos valores do array. É o equivalente de string[].

Agora vamos a um exemplo mais complexo, onde não sabemos o tipo da informação que poderá ser passada para uma função:

```sh
function example<T>(arg: T): T {
	return arg;
}
```

Nesse caso, declaramos uma função example que recebe um argumento do tipo T e retorna um valor do tipo T. Então:

```sh
const value = example<string>("Typescript");
console.log(value) // irá printar o valor "Typescript"
```

# Type assertions
É possível atribuir manualmente um tipo utilizando Type assertions. Exemplo:

```sh
const seller: any = "John Doe"; // declarado como any
const characterLength: number = (seller as string).length; // tipado como string
```

Fonte: https://www.aluiziodeveloper.com.br/um-pouco-mais-sobre-typescript/)