class Phecda.Routers.AccountsRouter extends Backbone.Router
  initialize: (options) ->
    @accounts = new Phecda.Collections.AccountsCollection()
    @accounts.reset options.accounts

  routes:
    "new"      : "newAccount"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newAccount: ->
    @view = new Phecda.Views.Accounts.NewView(collection: @accounts)
    $("#accounts").html(@view.render().el)

  index: ->
    @view = new Phecda.Views.Accounts.IndexView(accounts: @accounts)
    $("#accounts").html(@view.render().el)

  show: (id) ->
    account = @accounts.get(id)

    @view = new Phecda.Views.Accounts.ShowView(model: account)
    $("#accounts").html(@view.render().el)

  edit: (id) ->
    account = @accounts.get(id)

    @view = new Phecda.Views.Accounts.EditView(model: account)
    $("#accounts").html(@view.render().el)
