# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.App ?= {}
this.App.view_controllers ?= {}

class RoomsViewController
  room_id: null
  show: ->
    console.log 'connect chat room'
    App.cable.subscriptions.remove(App.chat) if App.chat?
    App.chat = App.cable.subscriptions.create { channel: 'ChatChannel', room_id: @room_id },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        message = $('<p>').text(data['content'])
        container = $('<div>').append(message)
        $('#messages').append(container)

      speak: (message) ->
        @perform 'speak', message: message
    return

this.App.view_controllers.rooms = new RoomsViewController