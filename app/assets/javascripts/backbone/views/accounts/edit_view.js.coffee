Phecda.Views.Accounts ||= {}

class Phecda.Views.Accounts.EditView extends Backbone.View
  template: JST["backbone/templates/accounts/edit"]

  events:
    "submit #edit-account": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (account) =>
        @model = account
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
