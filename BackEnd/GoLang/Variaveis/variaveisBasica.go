package main

import "fmt"

var nome string
var idade int
var moradia bool
var salario float64

//Rune: para caracteres especiais
var palavra rune

func main() {

	//Strings, que podem ser adicionadas com +.
	fmt.Println("go" + "lang")
	fmt.Printf("Meu nome e: %s\r\n", nome)

	//Booleanos, com operadores booleanos como você esperaria.
	fmt.Printf("Minha casa e propria: %v\r\n", moradia)

	//Inteiros e flutuantes.
	fmt.Printf("Minha idade e: %d\r\n", idade)
	fmt.Printf("Meu salario e: %f\r\n", salario)

	var a = "initial"
	fmt.Println(a)

	//Pode declarar várias variáveis ​​de uma vez.
	//Variáveis ​​declaradas sem uma inicialização correspondente têm valor zero .
	var e int
	var b, c int = 1, 2
	fmt.Println(b, c, e)

	//Sintaxe é um atalho para declarar e inicializar uma variável
	f := "apple"
	fmt.Println(f)

	//Calculos.
	fmt.Println("1+1 =", 1+1)
	fmt.Println("7.0/3.0 =", 7.0/3.0)
}
