package routes

import (
	"apiConsumer/services"
	"apiConsumer/utils"
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

//InterfaceRoutes interface utilizada para publicação e visualizacao da camadas
type InterfaceRoutes interface {
	AgendaRoutes(w http.ResponseWriter, r *http.Request)
}

//AgendaRoutes Rotas que captura a requisição e envia as resposta para os servicos solicitante
func AgendaRoutes(w http.ResponseWriter, r *http.Request) {
	pathParams := mux.Vars(r)
	configuration := utils.GetConfig()

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	if val, ok := pathParams["dataAtual"]; ok {
		b, err := json.Marshal(services.ServiceAgenda(val, configuration.Urlagenda))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(`{"error": "error marshalling data"}`))
			return
		}
		w.WriteHeader(http.StatusOK)
		w.Write(b)
		return

	}
}
