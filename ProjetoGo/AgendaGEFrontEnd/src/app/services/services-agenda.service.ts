import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root'
})

export class ServicesAgendaService {

  constructor(private http: HttpClient) {

   }

  getGame(_objTarget:string): Observable<any>{
   if(localStorage.getItem('dataSource') == null){
      return this.http
      .get<any>("http://localhost:8000/api/v1/agenda/"+_objTarget);
    }
  }  
}
