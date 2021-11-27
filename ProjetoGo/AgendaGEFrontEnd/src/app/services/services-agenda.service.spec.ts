import { TestBed } from '@angular/core/testing';

import { ServicesAgendaService } from './services-agenda.service';

describe('ServicesAgendaService', () => {
  let service: ServicesAgendaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ServicesAgendaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
