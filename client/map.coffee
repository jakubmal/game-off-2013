class Map
  constructor: (@$element) ->

  change: (fields) ->
    @$element.html ''
    x = 0
    fields.forEach (row) =>
      $row = $('<div></div>').addClass 'row'

      y = 0
      row.forEach (field) ->
        $field = $('<div></div>').addClass 'hexagon'
        $field.attr 'data-x', x
        $field.attr 'data-y', y

        $field.addClass 'land' if field.type == 'land'
        $field.addClass 'water' if field.type == 'water'

        $field.addClass 'capital' if field.isCapital
        $field.addClass 'city' if field.isCity

        $field.addClass "player-#{field.player.color}" if field.player

        $row.append $field
        y++

      @$element.append $row
      x++

@Map = Map
