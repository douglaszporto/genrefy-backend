# Genrefy

Uma simples aplicação Ruby on Rails que conecta ao spotify e obtem uma lista dos artistas seguidos pelo usuário.

## Dependências do sistema
 - Ruby 2.3.3p222 (2016-11-21 revision 56859) [i386-mingw32]
 - Rails 5.1.6.1
 - Bundler version 1.15.3

## Instalação
```
git clone https://github.com/douglaszporto/genrefy-backend.git
cd genrefy-backend
bundle install
```

## Database

```
rails db:migrate
```

## Iniciar servidor
```
rails s -p 3000
```
É importante que o servidr esteja rodando na porta 3000, caso contrário o front-end não funcionará.