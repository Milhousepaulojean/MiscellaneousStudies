# GitFlow

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

# Step by Step Utilizando GitFlow com Extensao

Siga o passo a passo com uso do GitFlow

- Verifique antes se ja tem instalado o git flow em seu computador
- Caso nao tenha um branch de developer e possivel criar com este commando: 
    
    ```sh
        git branch develop git push -u origin develop
    ```
- Para executar a biblioteca do GitFlow, basta usar o seguinte comando:
    ```sh
        git flow init
    ```
    
- Com uso da extensao inicio de uma feature

    ```sh
        git flow feature start feature_branch
    ```

- Ao termino da feature

    ```sh
        * Caso deseje atualizar a developer antes, siga os seguintes passos
            * Faca os ajustes necessarios;
            * Commit e efetue o Push.
            * Apos isso mude de branch para devoleper;
            * Atualize a branch de developer;
            * Volte para a Branch com a feature e efetue o seguinte comando:
                git rebase develop;
            * Neste momento a branch da feature ja estara atualizada com os ajustes feito de developer;
        git flow feature finish feature_branch
    ```

- Inicio de uma release

    ```sh
        git flow release start 0.1.0
    ```

- Fim de uma release

    ```sh
        git flow release finish '0.1.0'
    ```