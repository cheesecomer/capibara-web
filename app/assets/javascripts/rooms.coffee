# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.App ?= {}
this.App.view_controllers ?= {}

class RoomsViewController
  room_id: null
  user_id: null
  show: ->
    self = this
    App.cable.subscriptions.remove(App.chat) if App.chat?
    App.chat = App.cable.subscriptions.create { channel: 'ChatChannel', room_id: @room_id },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        nickname = $('<p>').addClass('nickname').text(data['sender']['nickname'])
        balloon = $('<div>').addClass('balloon').append($('<p>').html(data['content'].replace(/\r?\n/g, '<br>')))
        timestamp = $('<p>').addClass('timestamp').text(data['at'])
        container =
          $('<li>')
            .addClass('message')
            .addClass(if self.user_id == data['sender']['id'] then 'own' else 'others')
            .append(nickname)
            .append(balloon)
            .append(timestamp)

        $('.messages').append(container)


        $(window).scrollTop($(document).height() - $(window).height())

      speak: (message) ->
        @perform 'speak', message: message

    $('.send_message').on 'click', ->
      return if !$('.message_input').val()

      $('.send_message').prop("disabled", true);

      if App.chat.speak $('.message_input').val()
        $('.message_input').val('')

      $('.send_message').prop("disabled", false);
      return;

    $(window).scrollTop($(document).height() - $(window).height())

    return

this.App.view_controllers.rooms = new RoomsViewController