# MiscellaneousStudies  

Utilizando Git:

# 1.Inicializando um repositorio Git
    
```sh
   
```

# 2.Clonando um repositorio Git
    
```sh
    
```

<<<<<<< HEAD
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
=======
[1.Init](https://github.com/Milhousepaulojean/MiscellaneousStudies/blob/Git/README.md#1inicializando-um-repositorio-git)  
[2.Clone](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#2clonando-um-repositorio-git)  
[3.Branch](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#3utilizando-diferentes-repositorio-git)  
[4.Add](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#4adicionando-mudancas-nos-arquivos)  
[5.Stash](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#5utilizando-stash)  
[6.Commit](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#6utilizando-commit)  
[7.Push](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#7utilizando-push)  
[8.Historicos](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#8utilizando-logshistorico)  
[9.Rebase](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#9utilizando-rebase)  
[10.Revert](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#10utilizando-revert)  
[11.Issues](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#11utilizando-issues)  
[12.Pull-Request](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#12utilizando-pull-request)  
[13.WorkFlow](https://github.com/Milhousepaulojean/MiscellaneousStudies/tree/master/Infra/Git#13utilizando-workflow)  
>>>>>>> d2fe8e2 (Update README.md)

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
