class Map
  constructor: (@$element) ->

  change: (fields) ->
    @$element.html ''
    fields.forEach (row) =>
      $row = $('<div></div>').addClass 'row'

      row.forEach (field) ->
        $field = $('<div></div>').addClass 'hexagon'

        $field.addClass 'land' if field.type == 'land'
        $field.addClass 'water' if field.type == 'water'

        $field.addClass 'capital' if field.isCapital
        $field.addClass 'city' if field.isCity

        $field.addClass "player-#{field.player.color}" if field.player

        $row.append $field

      @$element.append $row

@Map = Map
