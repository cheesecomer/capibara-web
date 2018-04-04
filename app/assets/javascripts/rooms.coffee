# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.App ?= {}
this.App.view_controllers ?= {}

class RoomsViewController
  room_id: null
  user_id: null
  index: ->
    return

this.App.view_controllers.rooms = new RoomsViewController