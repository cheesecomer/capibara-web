# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.App ?= {}
this.App.view_controllers ?= {}

class RoomsViewController
  room_id: null
  user_id: null
  index: ->
    $('button[data-modal]')
      .on 'click', ()->
        $(".modal[data-modal='#{$(this).data('modal')}']").modal('show')
    $('.modal [data-submit]')
      .on 'click', ->
        $(@).parents('.modal').find('button').prop("disabled", true)
        $($(@).data('submit')).submit()
    $('.modal')
      .on 'show.bs.modal', () ->
        $(@).parents('.modal').find('button').prop("disabled", false)
        $('.error[data-attribute]').empty()
        $('.error[data-attribute]').hide()
    $('.modal form')
      .on 'ajax:error', (event, xhr, status, error) ->
        $('.error[data-attribute]').empty()
        $('.error[data-attribute]').hide()
        xhr.responseJSON.errors.forEach (v) ->
          $(".modal form [data-attribute='#{v.attribute}']").append $('<p>').text(v.message)
        $('.error[data-attribute]').not(':empty').show()
        $(@).parents('.modal').find('button').prop("disabled", false)
      .on 'ajax:success', (event, data, status, xhr) ->
        $('.error[data-attribute]').empty()
        $('.error[data-attribute]').hide()
        $(@).parents('.modal').find('button').prop("disabled", false)
        Turbolinks.visit window.location.toString(), { action: 'replace' }
    return

this.App.view_controllers.rooms = new RoomsViewController