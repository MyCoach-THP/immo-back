# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## How to use

1. Génération du secret
  * `rake secret`
  * Copie de la string générée
  * `EDITOR=nano rails credentials:edit`
  * Ajout en bas du fichier de :
  ```bash
  devise:
    jwt_secret_key: [clé copiée] // ⚠ Il faut mettre 2 espaces au début de cette ligne
  ```