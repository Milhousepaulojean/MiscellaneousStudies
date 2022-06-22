Feature: teste de chamar url

  Scenario: chamada da url
    Given chamar a url "\urlexemplo"
    When verificar qual foi o retorno
    Then precisa ser igual a "200"
