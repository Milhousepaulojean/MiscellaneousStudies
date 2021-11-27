import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AgendaComponent } from './agenda/agenda.component';

import {ServicesAgendaService} from './services/services-agenda.service'
import { HttpClientModule } from '@angular/common/http';
import { HeaderAgendaComponent } from './agenda/header-agenda/header-agenda.component';
import { BodyAgendaComponent } from './agenda/body-agenda/body-agenda.component';
import { DatePipe, registerLocaleData } from '@angular/common';
import { LOCALE_ID } from '@angular/core';
import localeBr from '@angular/common/locales/pt';

registerLocaleData(localeBr, 'pt')

@NgModule({
  declarations: [
    AppComponent,
    AgendaComponent,
    HeaderAgendaComponent,
    BodyAgendaComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule    
  ],
  providers: [ServicesAgendaService, 
              DatePipe,
              { provide: LOCALE_ID, useValue: 'pt' }
            ],
  bootstrap: [AppComponent]
})
export class AppModule { }
