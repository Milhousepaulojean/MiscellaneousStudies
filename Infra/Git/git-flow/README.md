# Step by Step Utilizando GitFlow com Extensao

    
    - Verifique antes se ja tem instalado o git flow em seu computador
    ```sh
        git branch develop git push -u origin develop
    ```

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
