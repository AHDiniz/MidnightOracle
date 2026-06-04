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

* 400: Erro relacionado ao body da requisição,
ou credenciais erradas no `auth/login`
* 401: Erro ao ler o header de token de acesso
* 500: Erro interno do servidor

## Módulos

### Auth

Endpoints de registro, login, e info de usuário

#### `/auth/register`

Cria um usuário novo

* Método POST;
* Recebe um body em JSON no formato:
  
```ts
{
  username: str,
  password: str,
  email: str,
}
```

Se bem sucedido, o usuário é criado e retorna código 201 com corpo vazio

#### `/auth/login`

Autentica um usuário com o sistema

* Método POST
* Recebe um body em JSON no formato:

```ts
{
  username: str,
  password: str,
}
```

Se bem sucedido, retorna código 200 com o token de acesso no body,
no campo `bearer_token`

#### `/auth/me`

Retorna as informações de um usuário autenticado

* Método GET
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

#### `/feed`

Endpoint para operações que não afetam um feed específico do usuário.
A funcionalidade do endpoint depende do método HTTP:

* Método GET: Listagem dos feeds do usuário
* Método POST: Registra um novo feed para o usuário
  * Lê todas as informações do feed a partir do link
  * Recebe um body em JSON no formato:

  ```ts
  {
    feed_url: str,
  }
  ```

#### `/feed/{id}`

Endpoint para operações que afetam um feed específico do usuário.
A funcionalidade do endpoint depende do método HTTP:

* Método PATCH: Atualiza os metadados do feed passado (título, descrição, etc)
* Método DELETE: Remove o feed RSS da lista de feeds do usuário
