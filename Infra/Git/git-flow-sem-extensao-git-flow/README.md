# GitFlow

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

# Step by Step Utilizando GitFlow com Extensao

Segue um passo a passo com uso do GitFlow

- Caso nao tenha a extensao instalada basta seguir os passos abaixos:
    
    ```sh
        git branch develop 
        git push -u origin develop
    ```
    
- sEM uso da extensao inicio de uma feature

    ```sh
        git checkout -b feature/feature_branch
    ```

- Ao termino da feature, atualize a branch de develop e

    ```sh
        git rebase
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