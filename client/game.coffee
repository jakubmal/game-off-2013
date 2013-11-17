Player = @Player

socket = io.connect 'http://localhost:3000'
socket.on 'welcome', () ->
  console.log "key: #{window.key}"
  window.player = player = new Player socket, window.key

$ ->
  $('.fn-end-turn').click ->
    window.player.endTurn()
