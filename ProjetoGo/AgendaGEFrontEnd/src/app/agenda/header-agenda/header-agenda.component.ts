import { Component, ElementRef, OnInit, ViewChild, Renderer2 } from '@angular/core';
import { DatePipe, formatDate } from '@angular/common';
import { ServicesAgendaService } from '../../services/services-agenda.service';

@Component({
  selector: 'app-header-agenda',
  templateUrl: './header-agenda.component.html',
  styleUrls: ['./header-agenda.component.css']
})

export class HeaderAgendaComponent implements OnInit {

  hoje = Date.now();
  numberclick = 0;
  dt = new Date();
  today: number = Date.now();
  @ViewChild('titileData') titileData: ElementRef;

  constructor(
    private renderer: Renderer2,
    private servicesagenda: ServicesAgendaService,
    private datePipe: DatePipe) {

  }

  ngOnInit(): void {
    this.DateToday()
  }

  //Funcionalidade de DataAtual
  public DateToday() {
    this.callservices(this.hoje);
  }

  public clickDate(event) {

    localStorage.clear();

    switch (event.srcElement.innerHTML) {
      case "&gt;":
        console.log("futuro")
        console.log(this.numberclick)
        if (this.numberclick == 0) {
          this.changeTitle("Amanhã");
          this.numberclick = this.numberclick + 1;
          this.callservices(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000));
        } else {
          this.numberclick = this.numberclick + 1;
          this.changeTitle(formatDate(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000), 'EEEE, dd/MM', 'pt-BR'));
          this.callservices(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000));
        }
        break;
      default:
          this.numberclick = this.numberclick - 1;
          if (this.numberclick == -1) {
            console.log(this.numberclick)
            this.changeTitle("Ontem");
            this.numberclick = this.numberclick - 1;
            this.callservices(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000));
          } else {
            this.numberclick = this.numberclick - 1;
            this.changeTitle(formatDate(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000), 'EEEE, dd/MM', 'pt-BR'));
            this.callservices(new Date(this.hoje + this.numberclick * 24 * 60 * 60 * 1000));
          }

        break;
    }    
  }

  callservices(date: any) {

    if (localStorage.getItem('dataSource') == null) {
      this.servicesagenda.getGame(this.datePipe.transform(date, 'yyyy-MM-dd', 'pt-BR').replace("2020", "2019")).subscribe(
        r => localStorage.setItem('dataSource', r)
      );
    }

  }

  changeTitle(text: string) {
    this.renderer.setProperty(this.titileData.nativeElement, 'innerHTML', text);
  }

}
