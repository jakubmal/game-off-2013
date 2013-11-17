class Map
  constructor: () ->
    @initFields()

  initFields: () ->
    @fields = [1..21].map (i) =>
      if i % 2
        [1..10].map () => @initField()
      else
        [1..9].map () => @initField()

  initField: () ->
    type: 'land'
    isCity: false
    isCapital: false
    owner: null
    army: 0

module.exports = Map
