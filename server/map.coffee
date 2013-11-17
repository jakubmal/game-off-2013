_ = require 'underscore'
# MapGen = require('./mapGen')
class Map
  constructor: () ->
    # @mapGen = new MapGen()
    # @mapGen.generate(19,11)
    @initFields()

  initFields: () ->
    @fields = [1..19].map (i) =>
      if i % 2
        [1..10].map (e) => @initField(i,e)
      else
        [1..11].map (e) => @initField(i,e)

  initCapitals: (players) ->

    playerRed = _.findWhere players, color: 'red'
    @fields[2][0].isCapital = true
    @fields[2][0].type = "land"
    @fields[2][0].player = playerRed
    @assignNeighboursTo {x: 2, y: 0}, playerRed

    # @fields[16][0].isCapital = true
    # @fields[16][0].player = color: 'blue'

    playerGreen = _.findWhere players, color: 'green'
    @fields[16][9].isCapital = true
    @fields[16][9].type = "land"
    @fields[16][9].player = playerGreen
    @assignNeighboursTo {x: 16, y: 9}, playerGreen

    # @fields[2][9].isCapital = true
    # @fields[2][9].player = color: 'purple'


  initField: (i,e) ->
    isCity = Math.random() > 0.9

    isCity: isCity
    type: if isCity || Math.random() > 0.1 then "land" else "water"
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

  getAllFields: () -> _.flatten @fields

  genArmies: () ->
    fields = @getAllFields()
    fields = fields.filter (f) -> f.player?
    fieldsByPlayer = _.groupBy fields, (f) -> f.player.color

    _.pairs(fieldsByPlayer).forEach ([color, fields]) ->
      console.log color, fields

      fieldsCount = fields.length
      cities = fields.filter (f) -> f.isCity || f.isCapital

      armyPerCity = parseInt fields.length / cities.length
      console.log cities
      cities.forEach (c) ->

        c.army += 5 unless c.isCapital
        c.army += 15 if c.isCapital
        c.army += armyPerCity

  isInMap: ({x, y}) -> @fields[x]?[y]?

  makeMove: (source, dest) ->
    sourceField = @fields[source.x][source.y]
    destField = @fields[dest.x][dest.y]

    console.log sourceField, destField

    if sourceField.player != destField.player

      if sourceField.army > destField.army
        destField.army = sourceField.army - destField.army
        sourceField.army = 0
        destField.player = sourceField.player
        @assignNeighboursTo dest, sourceField.player
      else
        destField.army -= sourceField.army
        sourceField.army = 0

    else

      destField.army += sourceField.army
      sourceField.army = 0
      destField.player = sourceField.player
      @assignNeighboursTo dest, sourceField.player

module.exports = Map
