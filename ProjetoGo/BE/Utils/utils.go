package utils

import (
	"github.com/tkanos/gonfig"
)

//Configuration Struct para informações que serao informadas via sistema
type Configuration struct {
	Port      string
	Pathfile  string
	Urlagenda string
}

//GetConfig Captura as informações nos arquivos de configuraçoes
func GetConfig(params ...string) Configuration {
	configuration := Configuration{}

	err := gonfig.GetConf("config/config.json", &configuration)
	if err != nil {
		return configuration
	}

	return configuration
}
