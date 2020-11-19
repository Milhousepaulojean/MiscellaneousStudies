# MiscellaneousStudies  

Utilizando Git por:

    #Log
        - git log
        - git log --author="Paulo"
        - git shortlog: Mostra todos os logs no por usuario no formato curto;
        - git shortlog  -sn: Mostra todos os logs por quantidade;
        - git log -graph: Mostra a rastreabilidade no formato de logs no Git;

    #Show
    - git show id_do_commit: Mostra o arquivos que foram alterados dentro do Commit;

    #Diff
     - git diff: Verifica altercoes concluidas;
     - git diff --name-only: Verifica apenas o nome do arquivo;
    
    #Rollback porem ainda nao esta em stage
    - Se o arquivo ainda nao estiver em stage ou necessite voltar a versao
        - git checkout nomedoarquivo

    #Rollback porem ja esta em stage
    - Se o arquivo em estiver em stage ou necessite voltar a versao    
        - git reset HEAD: retira todos os arquivos de stages;
        - git reset HEAD file_our_path_with_file: retira todos os arquivos de stages;

    git reset
        --soft:
        --mixed:
        --hard:

        Apos hard git push --force