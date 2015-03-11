contextClass =
  window.AudioContext || 
  window.webkitAudioContext || 
  window.mozAudioContext || 
  window.oAudioContext || 
  window.msAudioContext

if contextClass
  # Web Audio API is available.
  context = new contextClass()

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
    @node.gain.linearRampToValueAtTime(peak/3, context.currentTime + 0.05);
    @node.gain.linearRampToValueAtTime(0, context.currentTime + (tempo/2000));

class Voice
  constructor: (@parts)-> 
    self = @
    @id = @parts.id
    carrier = new OSC("sine", @parts.carrier)
    fm = new OSC("sine", @parts.fm, 50)
    am = new OSC("sine", @parts.am, 0.125)
    tempo = @parts.tempo #((@parts.tempo/255) * 19000) + 1000
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

    self.impulse(env, amEnv, fmEnv, tempo)

    @interval = setInterval -> 
      self.impulse(env, amEnv, fmEnv, tempo)
    , tempo

    self

  impulse : (env, amEnv, fmEnv, tempo)-> 
    env.addEventToQueue(tempo) 
    amEnv.addEventToQueue(tempo/2, 1) 
    fmEnv.addEventToQueue(tempo/2, 3) 

  end:->
    clearInterval(@interval)
