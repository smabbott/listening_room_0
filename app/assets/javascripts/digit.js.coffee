class window.DigitsController
  constructor: (ds, el)->
    @el = $(el)
    @digits = [] 
    for d in ds
      @addDigits(d)

  addDigit:(d, pid)->
    dig = new Digit(d, pid)
    @digits.push dig
    @el.append(dig.el)

  # TODO:
  removeDigit:(d)->
    for digit in @digits
      if (digit.parentId == d.id) 
        digit.end() 

  addDigits:(d)->
    ipBase10 = d.digits.split('.').map (i)->
      parseInt(i)

    for part in ipBase10
      @addDigit(part, d.id)


class Digit
  constructor:(@value, @parentId)->
    @el = $("<div class='digit'></div>")
    @animateCounter()
    @

  generateDigit: (num, digit)->
    for bit in [0..7]
      box = $("<div class='box'></div>")
      box.addClass('on') if @toBoolean(num[bit])
      @el.append(box)

  toBoolean: (b)->
    b == '1' or b == 1

  animateCounter: =>
    counter = 0
    self = @
    counterInterval = setInterval(->
      self.el.empty()
      self.generateDigit(IPParser.parseNum(counter), self.el)
      if counter == self.value
        clearInterval counterInterval
      counter++
    ,10)

  end:->
    @el.remove()
