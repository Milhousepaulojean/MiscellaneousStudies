package main

import "fmt"

var nome string
var idade int
var moradia bool
var salario float64

//Rune: para caracteres especiais
var palavra rune

func main() {
	fmt.Printf("Meu nome e: %s\r\n", nome)
	fmt.Printf("Minha idade e: %d\r\n", idade)
	fmt.Printf("Minha casa e propria: %v\r\n", moradia)
	fmt.Printf("Meu salario e: %f\r\n", salario)
}
