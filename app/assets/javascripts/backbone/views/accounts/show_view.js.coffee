Phecda.Views.Accounts ||= {}

class Phecda.Views.Accounts.ShowView extends Backbone.View
  template: JST["backbone/templates/accounts/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
