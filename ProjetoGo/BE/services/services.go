package services

import (
	"io/ioutil"
	"net/http"
	"strings"
)

//InterfaceServices interface utilizada para publicacao e visualizacao da camadas
type InterfaceServices interface {
	ServiceAgenda(valor string, url string)
}

//ServiceAgenda Serviço que captura todas as informacoes da Api;
func ServiceAgenda(valor string, url string) (resultstring string) {
	response, err := http.Get(strings.ReplaceAll(url, "_DATAENVIADA_", valor))
	if err != nil {
		panic(err)
	} else {
		data, _ := ioutil.ReadAll(response.Body)
		defer response.Body.Close()
		resultstring = string(data)
	}
	return resultstring
}
