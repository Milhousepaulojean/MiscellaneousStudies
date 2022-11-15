var _ = require('lodash');
module.exports = function (app) {
    this.callModelGetTypeUrlAntigaItems = async function name(params) {
        let i = 0;
        let j = 0;
        params.Items.map(objItem => {
            switch (objItem["cod_objt_aten"]) {
                case "8F8C717A-BFFC-4BFA-8E04-605361410172":
                    ++i
                    break;
                case "1D78CCB3-F250-446F-8F71-C1B50F8FBFE8":
                    ++j
                    break;
                default:
                    j;
                    break;
            }

        });

        let objresponse = {};
        objresponse.total = i + j;
        objresponse.Central = i;
        objresponse.CentralA = j;

        //console.log(`count total amigo: ${i}, \n count total sem amigo: ${j}`)
        return objresponse;
    }

    this.callModelGetTypeComTodoItens = async function name(paramsreq, paramsresp) {
        //Remove duplicates
        let uniqueContact = [...new Set(_.map(paramsresp.Items, "cod_objt_aten"))];
        console.log(uniqueContact);

        let objresponse = {};
        objresponse.organizacao = paramsreq.organizacao;
        objresponse.unidade_organizacional = paramsreq.unidade_organizacional;
        objresponse.cod_cli = paramsreq.cod_cli;
        objresponse.total_mensagem = paramsresp.Count;
        objresponse.list_mens = [];


        for (let indexuniqueContact = 0; indexuniqueContact < uniqueContact.length; indexuniqueContact++) {
            let objectarray = {};
            let i = 0;
            for (let indexparams = 0; indexparams < paramsresp.Items.length; indexparams++) {
                if (uniqueContact[indexuniqueContact] == paramsresp.Items[indexparams]["cod_objt_aten"]) {

                    if (objectarray.chatbot == undefined) {
                        objectarray.chatbot = uniqueContact[indexuniqueContact]
                    }

                    objectarray.count = ++i;
                }
            }
            objresponse.list_mens.push(objectarray);

        }


        return objresponse;

    }

    this.callModelGetTypeComItemEspecifico = async function name(paramsreq, paramsresp) {
        let objresponse = {};
        objresponse.organizacao = paramsreq.organizacao;
        objresponse.unidade_organizacional = paramsreq.unidade_organizacional;
        objresponse.cod_cli = paramsreq.cod_cli;
        objresponse.list_mens = [];

        let objectarray = {};
        objectarray.chatbot = paramsreq.chatbot;

        let i = 0;
        for (let indexparams = 0; indexparams < paramsresp.Items.length; indexparams++) {
            if (paramsreq.chatbot == paramsresp.Items[indexparams]["cod_objt_aten"]) {
                objectarray.count = ++i;
            }
        }
        if (objectarray.count == undefined) {
            objectarray.count = 0
        }
        objresponse.list_mens.push(objectarray);


        return objresponse;
    }

    this.callModelSendRepositoryDelete = async function name(paramsreq, paramsresp) {
        let objresponse = [];

        for (let indexparams = 0; indexparams < paramsresp.Items.length; indexparams++) {
            let objectarray = {};
            if (paramsreq.chatbot == paramsresp.Items[indexparams]["cod_objt_aten"]) {
                objectarray.organizacao = paramsreq.organizacao;
                objectarray.unidade_organizacional = paramsreq.unidade_organizacional;
                objectarray.cod_cli = paramsresp.Items[indexparams]["cod_objt_cli"];
                objresponse.push(objectarray);
            }
        }

        return objresponse;
    }

    this.callModelSendMessageDelete = function name(params) {
        let objresponse = {};
        if (params == true) {
            objresponse.mensagem = "Delete sucess";
        } else {
            objresponse.mensagem = "Itens not exist";
        }

        return objresponse;
    }

    this.callModelSendMessagePost = function name(params) {
        let objresponse = {};
        if (params == true) {
            objresponse.mensagem = "Post sucess";
        } else {
            objresponse.mensagem = "Itens not exist";
        }

        return objresponse;
    }
    return this;
}