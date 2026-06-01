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
  - Eu acho que a funcionalidade de ler o conteúdo dos feeds RSS a partir do XML já conta
- [ ] Lista 4 - Autorização
  - Não estava previsto no trabalho inicial, podemos adicionar o conceito de Admin,
  que pode ter uma funcionalidade de deletar outros usuários

## Funcionalidades para o trabalho final

- [x] Usuários
  - [x] Registrar
  - [x] Logar
- [ ] Feeds RSS
  - [x] Registrar Feeds
  - [x] Listar Feeds
  - [x] Atualizar info de Feeds
  - [ ] Deletar Feeds
- [ ] Itens de feed RSS
  - [ ] Listar Itens salvos
  - [ ] Salvar Itens
  - [ ] Deletar Itens
- [ ] Categorias
  - [ ] Criar novas
  - [ ] Atrelar a Feeds
    - [ ] Desatrelar
  - [ ] Atrelar a Itens
    - [ ] Desatrelar
