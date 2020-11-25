# MiscellaneousStudies  

Utilizando Git por:
# Log
    - git log
    - git log --author="Paulo"
    - git shortlog: Mostra todos os logs no por usuario no formato curto;
    - git shortlog  -sn: Mostra todos os logs por quantidade;
    - git log -graph: Mostra a rastreabilidade no formato de logs no Git;

# Show
    - git show id_do_commit: Mostra o arquivos que foram alterados dentro do Commit;

# Diff
    - git diff: Verifica altercoes concluidas;
    - git diff --name-only: Verifica apenas o nome do arquivo;
    
# Rollback porem ainda nao esta em stage
    - Se o arquivo ainda nao estiver em stage ou necessite voltar a versao
    - git checkout nomedoarquivo

# Rollback porem ja esta em stage
    - Se o arquivo em estiver em stage ou necessite voltar a versao    
        - git reset HEAD: retira todos os arquivos de stages;
        - git reset HEAD file_our_path_with_file: retira todos os arquivos de stages;

# git reset
        --soft: O primeiro tipo de reset é utilizado com a opção soft e move apenas o ponteiro HEAD para algum outro commit, sem alterar a área de stage ou o diretório de working. É importante notar que, de fato, a operação moverá o branch para o qual o HEAD aponta e, por consequência, moverá também o ponteiro HEAD.
            - Ex: $ git reset --soft HEAD~

        --mixed: O segundo tipo de reset pode ser utilizado com a opção mixed ou, por ser o tipo default, somente com o comando reset.

            - $ git reset HEAD~ ou git reset --mixed HEAD~
        
        --hard: O terceiro e mais perigoso tipo de reset é utilizado com a opção hard e não apenas descarta as alterações na área de stage como também reverte todas as alterações no diretório de working para o estado do commit que foi especificado no comando. Por exemplo, imagine um repositório no mesmo estado dos casos anteriores.

            - Ex: git reset --hard HEAD~

        Apos hard git push --force