import { Component, OnInit } from '@angular/core';
import { ServicesAgendaService } from '../../services/services-agenda.service';


@Component({
  selector: 'app-body-agenda',
  templateUrl: './body-agenda.component.html',
  styleUrls: ['./body-agenda.component.css']
})
export class BodyAgendaComponent implements OnInit {

  arrayobj = []
  arrayinfo = []

  constructor(private servicesagendaservice: ServicesAgendaService) { }

  ngOnInit(): void {

    if (localStorage.getItem('dataSource') == null) {
      var interval = setInterval(() => {
        this.jsonretorno();
        //this.arrayobj = this.servicesagendaservice.getArray();  
        if (localStorage.getItem('dataSource') != null) {
          clearInterval(interval);
        }
      }, 5000);
    }
  }

  jsonretorno() {
    let countjogo= 0;
    if (JSON.parse(localStorage.getItem('dataSource')) != null) {

      var jogos = Object.keys(JSON.parse(localStorage.getItem('dataSource')).resultados.jogos).map(e => JSON.parse(localStorage.getItem('dataSource')).resultados.jogos[e])
      var equipes = Object.keys(JSON.parse(localStorage.getItem('dataSource')).referencias.equipes).map(e => JSON.parse(localStorage.getItem('dataSource')).referencias.equipes[e]);
      var fases = Object.keys(JSON.parse(localStorage.getItem('dataSource')).referencias.fases).map(e => JSON.parse(localStorage.getItem('dataSource')).referencias.fases[e]);
      var edicoes = Object.keys(JSON.parse(localStorage.getItem('dataSource')).referencias.edicoes).map(e => JSON.parse(localStorage.getItem('dataSource')).referencias.edicoes[e]);
      var campeonato = Object.keys(JSON.parse(localStorage.getItem('dataSource')).referencias.campeonatos).map(e => JSON.parse(localStorage.getItem('dataSource')).referencias.campeonatos[e]);

      //NOME DO CAMPEONATO
      for (var i = 0; i < campeonato.length; i++) {        

        if(jogos.find(j => j["fase_id"] == fases.find(f => f["edicao_id"] == edicoes.find(e => e["campeonato_id"] === campeonato[i].campeonato_id).edicao_id).fase_id) != null){
          for (var j = 0; j < jogos.length; j++) {

            if (jogos[j]["fase_id"] === fases.find(f => f["edicao_id"] == edicoes.find(e => e["campeonato_id"] === campeonato[i].campeonato_id).edicao_id).fase_id) {
             
              this.arrayinfo.push(
                {
                  rodada: jogos[j].rodada,
                  equipemandanate: equipes.find(e => e["equipe_id"] === jogos[j].equipe_mandante_id).apelido,
                  escudoequipemandante: equipes.find(e => e["equipe_id"] === jogos[j].equipe_mandante_id).escudos["30x30"],
                  placarmandante: jogos[j].placar_oficial_mandante,
                  equipevisitante: equipes.find(e => e["equipe_id"] === jogos[j].equipe_visitante_id).apelido,
                  escudoequipevisitante: equipes.find(e => e["equipe_id"] === jogos[j].equipe_visitante_id).escudos["30x30"],
                  placarvisitante: jogos[j].placar_oficial_visitante  
                }
              );              
            }
          }
          this.arrayobj.push({ nomedocampeonato: campeonato[i].nome , info: this.arrayinfo });   
          this.arrayinfo = []      
        }        
      }
    }
    console.log(this.arrayobj)
  }

}
