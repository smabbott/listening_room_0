class window.DigitsController
  constructor: (ds, el)->
    @el = $(el)
    @digits = [] 
    for d in ds
      @addDigits(d)
      # dig = new Digit(d)
      
        # @el.append(digit)

  addDigit:(d)->
    dig = new Digit(d)
    @digits.push dig
    @el.append(dig.el)

    # TODO:
    # removeDigit:(d)->
    # for digit in @digits
    # if (digit.id == d.id) 
    # TODO: remove element based on id
    # digit.end() 

  addDigits:(d)->
    ipBase10 = d.split('.').map (i)->
      parseInt(i)

    for part in ipBase10
      @addDigit(part)


class Digit
  constructor:(@value)->
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

  # count: (counter)->
  #   debugger