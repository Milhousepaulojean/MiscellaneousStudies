import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BodyAgendaComponent } from './body-agenda.component';

describe('BodyAgendaComponent', () => {
  let component: BodyAgendaComponent;
  let fixture: ComponentFixture<BodyAgendaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BodyAgendaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BodyAgendaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
