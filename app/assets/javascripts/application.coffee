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
#= require bootstrap-sprockets

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
  return