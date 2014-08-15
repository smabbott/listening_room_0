contextClass =
  window.AudioContext || 
  window.webkitAudioContext || 
  window.mozAudioContext || 
  window.oAudioContext || 
  window.msAudioContext

window.room ?= {}
window.room.voicesController = {}

window.sampleips = [
  "50.201.141.30"
  ,"53.20.121.50"
  ,"153.120.213.250"
  ,"40.140.127.2"
  ,"140.127.2.40"
  ,"127.2.40.140"
  ,"2.40.140.127"
  ,"172.16.1.20"
  , "16.1.20.172"
  , "1.20.172.16"
  , "20.172.16.1"
  , "172.16.1.20"
  , "16.1.20.172"
  , "1.20.172.16"
]

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

    impulse(env, amEnv, fmEnv, tempo)

    setInterval -> 
      impulse(env, amEnv, fmEnv, tempo)
    , tempo


  window.room.voicesController = new VoicesController(ips)

  context.listener.setPosition(0, 0, 0);

  $('body').on 'unload', (e)->
    $.get '/ips/', {method:'delete'}, (e)->
