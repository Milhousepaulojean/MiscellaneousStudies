# MiscellaneousStudies  

Utilizando Git:

# 1.Inicializando um repositorio Git
    
```sh
   
```

# 2.Clonando um repositorio Git
    
```sh
    
```

# 3.Utilizando diferentes repositorio Git
    
```sh
    git branch | git branch --list: lista todas as ramificacoes  
    git branch nomedabranch: Cria uma branch local 
    git branch -d: Excluir a ramificação especificada. Esta é uma operação “segura” em que o Git impede que você exclua a ramificação se tiver mudanças não mescladas.  
    git branch -D: Forçar a exclusão da ramificação especificada, mesmo que ela tenha mudanças não mescladas.   Este é o comando a ser usado se você quiser excluir de modo permanente todas as confirmações associadas a uma linha particular de desenvolvimento.   
```
# 4.Adicionando Mudancas nos arquivos
    
```sh
    
```
# 5.Utilizando Stash
    
```sh
    
```
# 6.Utilizando Commit
    
```sh
     git commit: Abre um editor comum para digitar a mensagem.  
     git commit -a: Adiciona automaticamente todas as alterações no diretório de trabalho, apenas com as modificações nos arquivos monitorados e abre o editor aguardando a mensagem.  
     git commit -m: Adiciona uma mensagem sem precisar do editor.  
     git commit -am: Adiciona uma mensagem e os arquivos sem precisar do editor
     git commit --amend: A transmissão dessa opção modifica o último commit. Em vez de criar um novo commit, as mudanças preparadas são adicionadas ao commit anterior. Esse comando abre o editor de texto configurado no sistema e solicita a mudança da mensagem de commit especificada mais cedo. Mas lembrando nessa etapa ainda
     sera preciso utilzar o git add antes de utilizar o git comit --amend.        
```
# 7.Utilizando Push
    
```sh
    git push origin --delete crazy-experiment | git push origin :crazy-experiment: Isso vai enviar um sinal de exclusão para o repositório de origem remota que aciona uma exclusão da ramificação remota crazy-experiment.  
```
# 8.Utilizando Logs(Historico)
    
```sh
    git log: apresenta todos os logs;
    --oneline: Visibilidade dos logs em uma unica linha;
    --decorate: Destaca as informacoes por cores;
    
```
# 9.Utilizando Logs com Diff
    
```sh
    git log: apresenta todos os logs;
    --oneline: Visibilidade dos logs em uma unica linha;
    --decorate: Destaca as informacoes por cores;
    
```
# 10.Utilizando Rebase
    
```sh
    
```
# 11.Utilizando Revert
    
```sh
    
```
# 12.Utilizando Issues
    
```sh
    
```
# 13.Utilizando Pull-Request
    
```sh
    
```
# 14.Utilizando WorkFlow
    
```sh
    
```
# 15.Utilizando Pull
    
```sh
    git pull: Busque a cópia do remoto especificado do branch atual e imediatamente mescle-a na cópia local. 
    git pull --no-commit: Semelhante à chamada padrão, busca o conteúdo remoto, mas não cria um novo commit de mesclagem.  
    git pull --rebase: Igual ao pull anterior Em vez de usar git mergepara integrar a ramificação remota com a local, use git rebase.  
    git pull --verbose: Fornece saída detalhada durante um pull que exibe o conteúdo sendo baixado e os detalhes da mesclagem.  
```

# 16.Utilizando Merge
    
```sh
Ex
    git checkout branch_que_deseja_ser_mergiada
    git merge branch_das_alteracoes
```
# 16.Utilizando fetch
    
```sh
    git fetch: Sincroniza o pull dos commits remotos mais recentes;
```
