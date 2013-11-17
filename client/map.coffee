class Map
  constructor: (@$element) ->
    that = @
    console.log ".hexagon.army:not(.moved):not(.targetable).player-#{window.player.color}"
    @$element.on 'click', ".hexagon.army:not(.moved):not(.targetable)", (e) => @armyClicked e
    @$element.on 'click', '.hexagon.targetable', (e) => @targetClicked e
    $(document).on 'click', '.end-turn', @onEndTurn

    # @$element.on 'click', '.hexagon', @fieldClicked

  onEndTurn: () ->
    window.player.endTurn()

  change: (fields) ->
    @fields = fields

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

        $field.addClass 'army' if field.army
        $field.attr "data-army", field.army if field.army

        $field.addClass "player-#{field.player.color}" if field.player

        $row.append $field
        y++

      @$element.append $row
      x++

  armyClicked: (e) ->
    @$source = $ e.target


    console.log ".player-#{window.player.color}"
    return unless @$source.hasClass("player-#{window.player.color}")

    @sourcePoint =
      x: parseInt @$source.attr('data-x')
      y: parseInt @$source.attr('data-y')

    neighbours = @getNeighbours @sourcePoint
    neighbours.forEach ({x, y}) =>
      @$element.find("[data-x=#{x}][data-y=#{y}]:not(.water)").addClass 'targetable'

  targetClicked: (e) ->
    console.log 'dick'
    @$target = $ e.target
    point =
      x: parseInt @$target.attr('data-x')
      y: parseInt @$target.attr('data-y')

    window.player.makeMove
      source: @sourcePoint
      dest: point


  getNeighbours: ({x, y}) ->
    results = []

    results.push point if @isInMap(point = { x: x - 2, y: y })
    results.push point if @isInMap(point = { x: x + 2, y: y })

    results.push point if @isInMap(point = { x: x - 1, y: y })
    results.push point if @isInMap(point = { x: x + 1, y: y })

    if x % 2 == 0
      results.push point if @isInMap(point = { x: x - 1, y: y + 1 })
      results.push point if @isInMap(point = { x: x + 1, y: y + 1 })
    else
      results.push point if @isInMap(point = { x: x - 1, y: y - 1 })
      results.push point if @isInMap(point = { x: x + 1, y: y - 1 })

    results

  # list of coords which are 2 steps away from given point
  getFarNeighbours: (point) ->
    closeNeighbours = @getNeighbours(point)
    farNeighbours = closeNeighbours.map (p) => @getNeighbours(p)
    allNeighbours = closeNeighbours.concat(_.flatten(farNeighbours, true))

    allNeighbours = _.uniq(allNeighbours, false, ({x, y}) -> x + 1000 * y)
    _.without(allNeighbours, _.findWhere(allNeighbours, point))

  isInMap: ({x, y}) -> @fields[x]?[y]?



@Map = Map
