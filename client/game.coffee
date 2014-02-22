Player = @Player

socket = io.connect 'http://192.168.1.26:3000'
socket.on 'welcome', () ->
  console.log "key: #{window.key}"
  window.player = player = new Player socket, window.key

  $map = $ '#container .map'
  window.map = map = new Map $map
  player.onMapChange = (fields) -> map.change fields

$ ->
  $('.end-turn').click ->
    window.player.endTurn()
  $('.surrender').click ->
  	console.log 'Surrender'
  	window.player.surrender()
  $('.give-speach').click ->
  	console.log 'Give speach'
  	window.player.giveSpeach()