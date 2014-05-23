Phecda.Views.Accounts ||= {}

class Phecda.Views.Accounts.NewView extends Backbone.View
  template: JST["backbone/templates/accounts/new"]

  events:
    "submit #new-account": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (account) =>
        @model = account
        window.location.hash = "/#{@model.id}"

      error: (account, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
