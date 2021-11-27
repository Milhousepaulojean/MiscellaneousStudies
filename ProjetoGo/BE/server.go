package main

import (
	"apiConsumer/utils"

	"apiConsumer/routes"
	"fmt"

	"github.com/gorilla/mux"

	"log"
	"net/http"
)

/// Funcionalidade para Star da Aplicação

func main() {
	r := mux.NewRouter()
	configuration := utils.GetConfig()
	log.Println("Server Up in port", configuration.Port)
	api := r.PathPrefix(configuration.Pathfile).Subrouter()
	api.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "api v1")
	})
	api.HandleFunc("/agenda/{dataAtual}", routes.AgendaRoutes).Methods(http.MethodGet)

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", configuration.Port), r))
}
