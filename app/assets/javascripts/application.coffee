# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require rails-ujs
#= require turbolinks
#= require_tree .
#= require jquery3
#= require jquery_ujs
#= require bootstrap

@App ?= {}

$(document)
  .on 'turbolinks:load', ->
    console.log 'turbolinks:load'
    App.view_controllers ?= {}

    $body = $("body")
    controller = $body.data("controller").split('/').join('_')
    actions = []
    actions.push $body.data("action")
    actions.push 'nav_active'

    activeController = App.view_controllers[controller]
    if activeController?
      $.each actions, (i, action) ->
        activeController[action]() if $.isFunction(activeController[action])

    return
  .on 'ajax:error', '[data-method="delete"]', () ->
    Turbolinks.visit window.location.toString(), { action: 'replace' }
    return
  .on 'ajax:success', '[data-method="delete"]', () ->
    Turbolinks.visit window.location.toString(), { action: 'replace' }
    return
  .on 'click', '.modal [data-submit]', ->
    $(@).parents('.modal').find('button').prop("disabled", true)
    $($(@).data('submit')).submit()
    return
  .on 'show.bs.modal', '.modal', () ->
    $(@).parents('.modal').find('button').prop("disabled", false)
    $('.error[data-attribute]').empty()
    $('.error[data-attribute]').hide()
    return
  .on 'ajax:error', '.modal form', (event, xhr, status, error) ->
    $(@).parents('.modal').find('button').prop("disabled", false)
    $('.error[data-attribute]').empty()
    $('.error[data-attribute]').hide()
    xhr.responseJSON.errors.forEach (v) ->
      $(".modal form [data-attribute='#{v.attribute}']").append $('<p>').text(v.message)
      return
    $('.error[data-attribute]').not(':empty').show()
    return
  .on 'ajax:success', '.modal form', (event, data, status, xhr) ->
    $(@).parents('.modal').find('button').prop("disabled", false)
    $('.error[data-attribute]').empty()
    $('.error[data-attribute]').hide()
    Turbolinks.visit window.location.toString(), { action: 'replace' }
    return
  return