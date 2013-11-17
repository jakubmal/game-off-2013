_ = require 'underscore'

class Map
  constructor: () ->
    @initFields()

  initFields: () ->
    @fields = [1..19].map (i) =>
      if i % 2
        [1..10].map () => @initField()
      else
        [1..11].map () => @initField()

  initCapitals: (players) ->

    playerRed = _.findWhere players, color: 'red'
    @fields[2][0].isCapital = true
    @fields[2][0].player = playerRed
    @assignNeighboursTo {x: 2, y: 0}, playerRed

    # @fields[16][0].isCapital = true
    # @fields[16][0].player = color: 'blue'

    playerGreen = _.findWhere players, color: 'green'
    @fields[16][9].isCapital = true
    @fields[16][9].player = playerGreen
    @assignNeighboursTo {x: 16, y: 9}, playerGreen

    # @fields[2][9].isCapital = true
    # @fields[2][9].player = color: 'purple'


  initField: () ->
    type: if Math.random() > 0.5 then 'land' else 'water'
    isCity: if Math.random() > 0.9 then true else false
    isCapital: false
    player: null
    army: 0

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

  assignNeighboursTo: (point, player) ->
    nghs = @getNeighbours point
    nghs = nghs.filter ({x, y}) =>
      field = @fields[x][y]
      return false if field.type == 'water'
      return false if field.army
      return false if field.isCity
      return false if field.isCapital
      true

    nghs.forEach ({x, y}) =>
      field = @fields[x][y]
      field.player = player

  isInMap: ({x, y}) -> @fields[x]?[y]?

module.exports = Map
