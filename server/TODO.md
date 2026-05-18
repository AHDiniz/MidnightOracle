# Roadmap

## Listas/Lab

- [x] Lista 1 - Autenticação
  - O sistema já tem autenticação completa. Dá para criar usuários pela rota
  `auth/register`, e eles se autenticam via a rota `auth/login`.
    - Um exemplo de rota que exige autenticação (e que o conteúdo varia por usuário)
    é a rota `auth/me`.
- [ ] Lista 2 - Funcionalidades CRUD
  - Eu argumentaria que já temos um exemplo de funcionalidade CRUD com
  a criação de usuários, apesar de ela estar limitada à Create e Read.
- [ ] Lista 3 - Funcionalidades não-CRUD
  - Eu acho que a funcionalidade de puxar o conteúdo dos feeds RSS conta para isso
- [ ] Lista 4 - Autorização
  - Não estava previsto no trabalho inicial, podemos adicionar o conceito de Admin,
  que pode ter uma funcionalidade de deletar outros usuários

## Funcionalidades para o trabalho final

- [x] Usuários
  - [x] Registrar
  - [x] Logar
- [ ] Feeds RSS
  - [ ] Listar Feeds
  - [ ] Registrar Feeds
  - [ ] Atualizar info de Feeds
- [ ] Itens de feed RSS
  - [ ] Listar Itens salvos
  - [ ] Salvar Itens
- [ ] Categorias
  - [ ] Criar novas
  - [ ] Atrelar a Feeds
  - [ ] Atrelar a Itens
