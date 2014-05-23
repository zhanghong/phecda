class Phecda.Models.Account extends Backbone.Model
  paramRoot: 'account'

  defaults:
    name: null
    phone: null
    email: null

class Phecda.Collections.AccountsCollection extends Backbone.Collection
  model: Phecda.Models.Account
  url: '/accounts'
