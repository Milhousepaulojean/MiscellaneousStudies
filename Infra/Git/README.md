# MiscellaneousStudies  

Utilizando Git por:


# 1.Inicializando um repositorio Git em uma pasta Local
    
```sh
    git init
```

# 2.Configuracao Locais no Git Config
    
```sh
    git config --global user.name "Paulo Jean"
    git config --global user.email "paulo@.com.br"
    git config user.name 
    git config user.email 
    git config --list


    Removendo chaves no git Config
    git config --global --unset Key
```

# 4.Git Clone
    
```sh
    git clone URL_DO_GIT
```

# 5.Adicionando modificacao em Arquivos Locais
```sh
    git add . : Para todos os arquivos de umn determinado diretorio;
    git add file : Para um unico arquivo;

```

# 6.Ciclo de Vida dos Arquivos
```sh
   Untracked: E o momento que o arquivo foi add no repositorio mas ainda nao foi Trackeado
   UnModifed: Apos adicionar o arquivo ele passa para estapa de UnModifed;
   Modifed: Etapa a qual o arquivo ja adicionado passaou por alguma modificacao
   Stage: Area local com versao finalizada, retornando ao estado de Unmodified.

```

# 7.Visualizar modificacao do Arquivo
```sh
    git status
    - Todos arquivos que foram criado ou passado por alguma modificacao.
```

# Log
```sh
    git log
    git log --author="Paulo"
    git shortlog: Mostra todos os logs no por usuario no formato curto;
    git shortlog  -sn: Mostra todos os logs por quantidade;
    git log --graph: Mostra a rastreabilidade no formato de logs no Git;
```

# Show
```sh
    git show id_do_commit: Mostra o arquivos que foram alterados dentro do Commit;
```
# Diff
```sh
    git diff: Verifica altercoes concluidas;
    git diff --name-only: Verifica apenas o nome do arquivo;
```
    
# Rollback porem ainda nao esta em stage
```sh
    Se o arquivo ainda nao estiver em stage ou necessite voltar a versao
    git checkout nomedoarquivo
```

# Rollback porem ja esta em stage
```sh
    - Se o arquivo em estiver em stage ou necessite voltar a versao    
        - git reset HEAD: retira todos os arquivos de stages;
        - git reset HEAD file_our_path_with_file: retira todos os arquivos de stages;
```

# Reset
```sh
     --soft: O primeiro tipo de reset é utilizado com a opção soft e move apenas o ponteiro HEAD para algum outro commit, sem alterar a área de stage ou o diretório de working. É importante notar que, de fato, a operação moverá o branch para o qual o HEAD aponta e, por consequência, moverá também o ponteiro HEAD.
        - Ex: $ git reset --soft HEAD~

    --mixed: O segundo tipo de reset pode ser utilizado com a opção mixed ou, por ser o tipo default, somente com o comando reset.

        - $ git reset HEAD~ ou git reset --mixed HEAD~
        
    --hard: O terceiro e mais perigoso tipo de reset é utilizado com a opção hard e não apenas descarta as alterações na área de stage como também reverte todas as alterações no diretório de working para o estado do commit que foi especificado no comando. Por exemplo, imagine um repositório no mesmo estado dos casos anteriores.

        - Ex: git reset --hard HEAD~

    Apos hard git push --force
```


# Commit modificacao em Stage
```sh
    git commit -m "Mensagem para Commitar";

    - Caso queira Comitar e adicionar os arquivos ao mesmo tempo basta passar o seguinte comando:

    git commit -am "Mensagem para Commitar";
```

# Push das modificacao do ambiente Local para Remoto
```sh
    git push
```

# Branch
```sh
    - Create Branch
        git checkout -b nome_da_branch
    - Delete Branch
        git checkout -D nome_da_branch
```

# TAGS
```sh
    - Delete Tags
        git tag -d value_da_tags
        git push origin :value_da_tags
```