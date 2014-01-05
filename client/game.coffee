Player = @Player

socket = io.connect 'http://192.168.1.15:3000'
socket.on 'welcome', () ->
  console.log "key: #{window.key}"
  window.player = player = new Player socket, window.key

  $map = $ '#container .map'
  window.map = map = new Map $map
  player.onMapChange = (fields) -> map.change fields

$ ->
  $('.fn-end-turn').click ->
    window.player.endTurn()
