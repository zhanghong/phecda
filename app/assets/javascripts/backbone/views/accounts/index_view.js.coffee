Phecda.Views.Accounts ||= {}

class Phecda.Views.Accounts.IndexView extends Backbone.View
  template: JST["backbone/templates/accounts/index"]

  initialize: () ->
    @options.accounts.bind('reset', @addAll)

  addAll: () =>
    @options.accounts.each(@addOne)

  addOne: (account) =>
    view = new Phecda.Views.Accounts.AccountView({model : account})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(accounts: @options.accounts.toJSON() ))
    @addAll()

    return this
