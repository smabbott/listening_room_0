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

  window.onbeforeunload = selfDestruct

  # remove the current user after an hour.
  selfDestruct = ->
    window.pusher.unsubscribe('presence-room-1');

  setInterval selfDestruct, 1000*60*60
