# Docker PHP 7.3 Laravel
## Descrição
Docker compose configurado com imagem PHP 7.3, Apache 2 e MySQL 8 para trabalhar com Laravel ou Lumen.

## Setup
Após o clone deste projeto, na mesma pasta, faça clone do projeto Laravel ou Lumen que será colocado dentro do docker da seguinte forma:

```
git clone {url_do_projeto} dev-system
```

Assim será criada uma pasta www dentro da pasta do docker.

### Database Dump
Caso tenha um dump de database e queira instalar junto ao docker, adicione os arquivos de sql em uma nova pasta chamada `initdb` dentro da raiz do docker.

### Instalando a imagem docker
Instale a imagem executando o comando `./start.sh` na pasta do docker

### Acesso
Acesse o projeto através da porta `443` com `https://localhost`
O banco de dados estará na porta padrão `3306`
