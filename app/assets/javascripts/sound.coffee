contextClass =
  window.AudioContext || 
  window.webkitAudioContext || 
  window.mozAudioContext || 
  window.oAudioContext || 
  window.msAudioContext

window.room ?= {}
window.room.voicesController = {}

if contextClass
  # Web Audio API is available.
  context = new contextClass()

$ ->

  # Create audio context
  context = new contextClass()

  class VoicesController
    constructor: (ips)->
      @voices = for ip in ips
        address = ip.address
        {address : createVoice(parseIp(ip.address))} # list of voices indexed by ip

    # figure out which are new, which have left
    # start new ones, stop exited ones, continue others
    update:(ips)->
      # stop voices if they are not in the list
      for k, v of ips
        @voices[k].end if (ips.indexOf(v) == -1)
      # create a new oscillator for each ip in ips if it doesn't already exist in @voices
      for ip in ips 
        @voices[ip] = createVoice(parseIp(ip)) if !@voices[ip]?

  class OSC
    constructor: (type, freq, gain=0.25) ->
      @osc = context.createOscillator()
      @gain = context.createGain()
      @osc.type = type
      @osc.frequency.value = freq
      @gain.gain.value = gain
      @osc.gain = @gain
      @osc.connect(@gain)
      @osc.start(0)

  class Envelope
    constructor: ->
      @node = context.createGain()
      @node.gain.value = 0
      @node

    addEventToQueue: (tempo, peak)->
      peak |= 1
      @node.gain.linearRampToValueAtTime(0, context.currentTime);
      @node.gain.linearRampToValueAtTime(peak, context.currentTime + 0.009);
      @node.gain.linearRampToValueAtTime(peak/3, context.currentTime + 0.05);
      @node.gain.linearRampToValueAtTime(0, context.currentTime + (tempo/2000));

  noteToFrequency = (note)->
    note = note - noteFrequencies.length - 1 if note > noteFrequencies.length
    noteFrequencies[note]

  parseIp = (ip)->
    ip.split('.').map (i)->
      parseInt(i)

  impulse = (env, amEnv, fmEnv, tempo)-> 
    env.addEventToQueue(tempo) 
    amEnv.addEventToQueue(tempo/2, 2) 
    fmEnv.addEventToQueue(tempo/2, 4) 

  createVoice = (ipParts)->
    carrier = new OSC("sine", noteToFrequency(ipParts[0]))
    fm = new OSC("sine", noteToFrequency(ipParts[1]), 50)
    am = new OSC("sine", noteToFrequency(ipParts[2]), 0.125)
    tempo = ((ipParts[3]/255) * 19000) + 1000
    env = new Envelope()
    amEnv = new Envelope()
    am.gain.connect(amEnv.node);
    amEnv.node.connect(carrier.osc.gain.gain)
    fmEnv = new Envelope()
    fm.gain.connect(fmEnv.node);
    fmEnv.node.connect(carrier.osc.frequency)
    carrier.gain.connect(env.node)

    # panning
    panner = context.createPanner()
    WIDTH = 5
    HEIGHT = 5
    centerX = WIDTH/2;
    centerY = HEIGHT/2;
    x = (Math.random()*10 - centerX)  / WIDTH;
    y = (Math.random()*10 - centerY) / HEIGHT;
    # Place the z coordinate slightly in behind the listener.
    z = -0.5;
    # Tweak multiplier as necessary.
    scaleFactor = 2;
    panner.setPosition(x * scaleFactor, y * scaleFactor, z);

    angle = Math.random()*360
    # Convert angle into a unit vector.
    panner.setOrientation(Math.cos(angle), -Math.sin(angle), 1);

    # Connect the node you want to spatialize to a panner.
    env.node.connect(panner);
    panner.connect(context.destination)

    # env.node.connect(context.destination)

    # for visualization
    # env.node.connect(A)

    impulse(env, amEnv, fmEnv, tempo)

    setInterval -> 
      impulse(env, amEnv, fmEnv, tempo)
    , tempo



  # # Temp Visualization stuff # #
  # A = context.createGainNode()
  # analyser = context.createAnalyser()
  # A.connect(analyser)
  # analyser.connect(context.destination)

  # freqDomain = new Uint8Array(analyser.frequencyBinCount)
  # analyser.getByteFrequencyData(freqDomain)
  # for count, i in analyser.frequencyBinCount
  #   value = freqDomain[i]
  #   percent = value / 256
  #   height = HEIGHT * percent
  #   offset = HEIGHT - height - 1
  #   barWidth = WIDTH/analyser.frequencyBinCount
  #   hue = i/analyser.frequencyBinCount * 360
  #   drawContext.fillStyle = 'hsl(' + hue + ', 100%, 50%)'
  #   drawContext.fillRect(i * barWidth, offset, barWidth, height)



  # createVoice(parseIp(ip))
  # createVoice(parseIp(ip2))
  # createVoice(parseIp(ip3))
  # createVoice(parseIp(ip4))
  # createVoice(parseIp(ip5))
  # createVoice(parseIp(ip6))
  # createVoice(parseIp(ip7))
  # createVoice(parseIp(ip8))
  # createVoice(parseIp(ip9))
  # createVoice(parseIp(ip10))
  # createVoice(parseIp(ip11))
  # createVoice(parseIp(ip12))
  # createVoice(parseIp(ip13))
  # createVoice(parseIp(ip14))
  # createVoice(parseIp(ip15))

  # TODO: pass ips to contoller. Let controller handle voice creation
  # for ip in ips
  #   do (ip)->
  #     createVoice(parseIp(ip.address))

  window.room.voicesController = new VoicesController(ips)

  context.listener.setPosition(0, 0, 0);

  # ipz = [3,4,5,6]
  # toRemove = []
  # ipz2 = [1,2,3,4]
  # for k, v of ipz
  #   console.log(ipz2.indexOf(v), v)
  #   toRemove.push(v) if (ipz2.indexOf(v) == -1)
  # console.log toRemove