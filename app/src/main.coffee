window.IPParser = 
  parseIP: (ip)-> 
    parts = ip.split('.').map (i)->
      IPParser.parseNum(i)

  parseNum: (num)->
    IPParser.pad(parseInt(num).toString(2), 8)

  pad: (s, l)->
    gap = l - s.length + 1
    while gap -= 1
      s = "0" + s
    s 


$ ->

  ip = window.sampleIP || '192.168.1.50' 

  toBoolean = (b)->
    b == '1' or b == 1

  generateDigit = (num, digit)->
    for bit in [0..7]
      box = $("<div class='box'></div>")
      box.addClass('on') if toBoolean(num[bit])
      digit.append(box)

  ipBase10 = ip.split('.').map (i)->
    parseInt(i)

  animateCounter = (counterWrapper, target)->
    counter = 0
    counterInterval = setInterval(`function(){count()}`, 10)
    count = ->
      counterWrapper.empty()
      generateDigit(IPParser.parseNum(counter), counterWrapper)
      if counter == target
        clearInterval counterInterval
      counter++

  for part in ipBase10
    digit = $("<div class='digit'></div>")
    $('body').append(digit)
    animateCounter(digit, part)
