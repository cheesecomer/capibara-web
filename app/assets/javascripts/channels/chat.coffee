# App.chat = App.cable.subscriptions.create { channel: 'ChatChannel', room_id: 1 },
#   connected: ->
#     # Called when the subscription is ready for use on the server

#   disconnected: ->
#     # Called when the subscription has been terminated by the server

#   received: (data) ->
#     message = $('<p>').text(data['message'])
#     container = $('<div>').append(message)
#     $('#messages').append(container)

#   speak: (message) ->
#     @perform 'speak', message: message
