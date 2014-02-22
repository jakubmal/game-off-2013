_ = require 'underscore'
MapGen = require './mapGen' 
Army = require './army'
Field = require './field'

SPEACH_COEFFICIENT = 2

class Map
  constructor: () ->
    @mapGen = new MapGen(19,11,24,0.6)
    @mapGen.generate()
    @initFields()

  initFields: () ->
    @fields = [1..19].map (i) =>
      if i % 2
        [1..10].map (e) => new Field(@mapGen.getCity(i-1,e-1),@mapGen.getType(i-1,e-1))
      else
        [1..11].map (e) => new Field(@mapGen.getCity(i-1,e-1),@mapGen.getType(i-1,e-1))

  initCapitals: (players) ->

    playerRed = _.findWhere players, color: 'red'
    @fields[2][0].city = 'capital'
    @fields[2][0].player = playerRed
    @assignNeighboursTo {x: 2, y: 0}, playerRed
    
    # playerBlue = _.findWhere players, color: 'blue'
    # @fields[16][0].city = 'capital'
    # @fields[16][0].player = playerBlue
    # @assignNeighboursTo {x: 16, y: 0}, playerBlue

    playerGreen = _.findWhere players, color: 'green'
    @fields[16][9].city = 'capital'
    @fields[16][9].player = playerGreen
    @assignNeighboursTo {x: 16, y: 9}, playerGreen

    # playerPurple = _.findWhere players, color: 'purple'
    # @fields[2][9].city = 'capital'
    # @fields[2][9].player = playerPurple
    # @assignNeighboursTo {x: 2, y: 9}, playerPurple

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

    return results

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
      return false if field.army?
      return false if field.isCity()
      return false if field.isCapital()
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
      fieldsCount = fields.length
      cities = fields.filter (f) -> f.isCity()

      armyPerCity = parseInt fields.length / cities.length
      cities.forEach (c) ->
        c.army = new Army(0,'land') if c.army == null
        c.army.count += 5 unless c.isCapital()
        c.army.count += 15 if c.isCapital()
        c.army.count += armyPerCity
        c.army.normalize()

  isInMap: ({x, y}) -> @fields[x]?[y]?

  makeMove: (source, dest) ->
    sourceField = @fields[source.x][source.y]
    destField = @fields[dest.x][dest.y]

    destField.player = sourceField.player unless destField.army?  #simplifies problem, but water is colored

    switch destField.player
      when null 
        destField.army = sourceField.army
        destField.player = sourceField.player
        @assignNeighboursTo dest, sourceField.player

      when sourceField.player
        if destField.army? then destField.army.join(sourceField.army)
        else destField.army = sourceField.army
        @assignNeighboursTo dest, sourceField.player
      
      # destField.player != sourceField.player
      else 
        if sourceField.army.getPower() > destField.army.getPower() 
          sourceField.army.fight(destField.army)
          destField.player.lost() if destField.city == 'capital'
          destField.army = sourceField.army
          destField.player = sourceField.player
          @assignNeighboursTo dest, sourceField.player
        else
          destField.army.fight(sourceField.army)

    sourceField.army = null
    sourceField.player = null if sourceField.type == 'water'
    # destField.army.learnFromTravel()

  removeArmies: (player) ->
    fields = @getAllFields()
    playerFields = fields.filter (f) -> f.player == player
    playerFields.forEach (field) ->
      field.army = null
      field.player = null

  giveSpeach: (player) ->
    fields = @getAllFields()
    playerFields = fields.filter (f) -> f.player == player && f.army?
    playerFields.forEach (field) ->
      field.army.morale = SPEACH_COEFFICIENT * field.army.morale
      
  countArmies: (player) ->
    fields = @getAllFields()
    playerFields = fields.filter (f) -> f.player == player && f.army?
    return playerFields.length

module.exports = Map
