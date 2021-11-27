import { formatDate } from '@angular/common';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-agenda',
  templateUrl: './agenda.component.html',
  styleUrls: ['./agenda.component.css']
})

export class AgendaComponent implements OnInit {

  cValue = formatDate(new Date(), 'dd/MM', 'en-US');

  arrayobj = []


  //Injeção de Depedencia
  constructor() { }

  ngOnInit(): void {

    //this.arrayobj = this.servicesagendaservice.getArray();

    // this.servicesagendaservice.getArray().subscribe(
    //   (res:any)=>{
    //     this.arrayobj = res
    //     //console.log('teste')
    //   }
    //   //data => this.arrayobj = data
    // )
    // console.log(this.arrayobj)
  }

}
  