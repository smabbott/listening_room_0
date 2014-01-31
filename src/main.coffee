$ ->

  ip = '192.168.1.50'
  # ip = [0..255].join('.')

  parseIP = (ip)-> 
    parts = ip.split('.').map (i)->
      parseNum(i)

  parseNum = (num)->
    pad(parseInt(num).toString(2), 8)

  pad = (s, l)->
    gap = l - s.length + 1
    while gap -= 1
      s = "0" + s
    s

  toBoolean = (b)->
    b == '1' or b == 1

  generateDigit = (num, digit)->
    for bit in [0..7]
      box = $("<div class='box'></div>")
      box.addClass('on') if toBoolean(num[bit])
      digit.append(box)

  # parsedIP = parseIP ip

  for part in parsedIP
    digit = $("<div class='digit'></div>")
    $('body').append(digit)
    generateDigit(part, digit)

  counterWrapper = $("<div class='digit counter'></div>")
  counter = 0
  counterInterval = setInterval(`function(){count()}`, 100)
  count = ->
    counterWrapper.empty()
    generateDigit(parseNum(counter), counterWrapper)
    if counter == 255
      clearInterval counterInterval
    counter++
  $('body').append(counterWrapper)
