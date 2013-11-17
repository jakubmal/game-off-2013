_ = require 'underscore'

class Map
  constructor: () ->
    @initFields()
    @initCapitals()

  initFields: () ->
    @fields = [1..19].map (i) =>
      if i % 2
        [1..10].map () => @initField()
      else
        [1..11].map () => @initField()

  initCapitals: () ->
    @fields[2][0].isCapital = true
    @fields[2][0].player = color: 'red'

    @fields[16][0].isCapital = true
    @fields[16][0].player = color: 'blue'

    @fields[16][9].isCapital = true
    @fields[16][9].player = color: 'green'

    @fields[2][9].isCapital = true
    @fields[2][9].player = color: 'purple'


  initField: () ->
    type: if Math.random() > 0.5 then 'land' else 'water'
    isCity: if Math.random() > 0.9 then true else false
    isCapital: false
    owner: null
    army: 0

  getNeighbours: ({x, y}) ->
    results = []

    results.push point if @isInMap(point = { x: x, y: y - 1 })
    results.push point if @isInMap(point = { x: x, y: y + 1 })

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

module.exports = Map
