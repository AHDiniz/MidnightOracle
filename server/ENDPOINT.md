# Endpoints

Descrição rápida dos endpoints do backend, separadas por módulos

## Notas gerais

### Autenticação

Com exceção do `auth/register` e `auth/login`, todos os outros endpoints
requerem um usuário autenticado, denotado pelo header `Authorization`, que
deve conter a string `Bearer`, seguida do token de acesso recebido no
endopoint `auth/login`.

Ex.: `Authorization: Bearer access_token_exemplo`

### Códigos de erro

Os endpoints do sistema compartilham o tratamento de erros.
Os erros possíveis são:

* 400: Erro ao ler o body da requisição, ou credenciais erradas no `auth/login`
* 401: Erro ao ler o header de token de acesso
* 500: Erro interno do servidor

## Módulos

### Auth

Endpoints de registro, login, e info de usuário

#### `auth/register`

Cria um usuário novo

* Requisição POST;
* Recebe um body em JSON no formato:
  
```ts
{
  username: str,
  password: str,
  email: str,
}
```

Se bem sucedido, o usuário é criado e retorna código 201 com corpo vazio

#### `auth/login`

Autentica um usuário com o sistema

* Requisição POST
* Recebe um body em JSON no formato:

```ts
{
  username: str,
  password: str,
}
```

Se bem sucedido, retorna código 200 com o token de acesso no body,
no campo `bearer_token`

#### `auth/me`

Retorna as informações de um usuário autenticado

* Requisição GET
* Requer autenticação
* Se bem sucedido, retorna código 200 com as informações no body, no formato:

```ts
{
  username: str,
  email: str,
}
```

### Feed

Endpoints relacionados ao manejamento dos feeds, expondo um CRUD completo.

Todos os endpoints requerem autenticação, e operam apenas nos feeds do usuário autenticado.
