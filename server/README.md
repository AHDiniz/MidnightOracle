# server

## Deployment

### Rodar migrations no BD

```sh
docker compose up cigogne # Precisa ter o arquivo .env preenchido
# ou
gleam run -m cigogne all # Precisa ter as envvars settadas
```

### Gerar funções do Squirrel

```sh
docker compose up squirrel # Precisa ter o arquivo .env preenchido
# ou
gleam run -m squirrel # Precisa ter as envvars settadas
```

### Rodar servidor

```sh
docker compose up server # Precisa ter o arquivo .env preenchido
# ou 
gleam run # Precisa ter as envvars settadas
```
