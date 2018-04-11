this.App ?= {}
this.App.view_controllers ?= {}

class InformationsViewController
  index: ->
    $('.modal')
      .on 'click', '[data-preview]', () ->
        target = $ $(@).data('clone')
        preview_form = target.clone().hide().attr
          action: $(@).data('preview')
          target: '_blank'
        preview_form.find('[name=_method]').val 'post'

        $('body').append preview_form
        preview_form.submit()
        preview_form.remove()
        preview_form = null
        return
    return

this.App.view_controllers.informations = new InformationsViewController