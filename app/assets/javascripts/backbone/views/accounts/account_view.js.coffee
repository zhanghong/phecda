Phecda.Views.Accounts ||= {}

class Phecda.Views.Accounts.AccountView extends Backbone.View
  template: JST["backbone/templates/accounts/account"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
