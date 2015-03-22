contextClass =
  window.AudioContext || 
  window.webkitAudioContext || 
  window.mozAudioContext || 
  window.oAudioContext || 
  window.msAudioContext

if contextClass
  # Web Audio API is available.
  context = new contextClass()

request = new XMLHttpRequest()
request.open('GET', '/impulse.wav', true)
request.responseType = 'arraybuffer'

# Reverb
drymix = context.createGain()
wetmix = context.createGain()
reverb = context.createConvolver()
# dynamic compression
compressor = context.createDynamicsCompressor()
drymix.connect(compressor)
drymix.connect(reverb)
wetmix.connect(compressor)
compressor.connect(context.destination);

impulseResponseBuffer = null
# Decode asynchronously
# Impulse sample for Rverb
# Sample from http://www.samplicity.com/bricasti-m7-impulse-responses/
request.onload = ->
  context.decodeAudioData request.response, (theBuffer)->
    # buffer = theBuffer
    impulseResponseBuffer = theBuffer
    reverb.buffer = impulseResponseBuffer;
    reverb.connect(wetmix);
    
  , (e)->
    console.log e

request.send();


class window.VoicesController
  constructor: (vs)->
    @voices = for v in vs
      # new Voice(parseIp(ip.address))
      new Voice(v)

  addVoice:(v)->
    @voices.push new Voice(v)

  removeVoice:(v)->
    for voice in @voices
      voice.end() if (voice.id == v.id) 

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
    @node.gain.linearRampToValueAtTime(peak/4, context.currentTime + 0.03);
    @node.gain.linearRampToValueAtTime(0, context.currentTime + (tempo/1000));

class Voice
  constructor: (@parts)-> 
    @endNode = null
    self = @
    @id = @parts.id
    carrier = new OSC("sine", @parts.carrier)
    fm = new OSC("sine", @parts.fm, 50)
    am = new OSC("sine", @parts.am, 0.125)
    tempo = @parts.tempo #((@parts.tempo/255) * 19000) + 1000
    lowpass = context.createBiquadFilter()
    lowpass.type = 'lowpass'
    lowpass.frequency.value = 1000
    env = new Envelope()
    amEnv = new Envelope()
    am.gain.connect(amEnv.node)
    amEnv.node.connect(carrier.osc.gain.gain)
    fmEnv = new Envelope()
    fm.gain.connect(fmEnv.node)
    fmEnv.node.connect(carrier.osc.frequency)
    # lowpassEnv = new Envelope()
    # lowpassEnv.node.connect(lowpass.frequency)
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

    env.node.connect(lowpass)
    lowpass.connect(panner) 
    panner.connect(drymix)

    self.impulse(env, amEnv, fmEnv, tempo)

    @interval = 0
    # fixme: want to delay start of each note
    # setInterval ->
    @interval = setInterval -> 
      self.impulse(env, amEnv, fmEnv, tempo)
    , tempo
    # , tempo

    self

  impulse : (env, amEnv, fmEnv, tempo)-> 
    env.addEventToQueue(tempo/2) 
    amEnv.addEventToQueue(tempo/2, 1) 
    fmEnv.addEventToQueue(tempo/2, 3) 

  end:->
    clearInterval(@interval)
