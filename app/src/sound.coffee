

$ ->
  ip = window.sampleIP
  ip2 = "50.201.141.30"
  ip3 = "53.20.121.50"
  ip4 = "153.120.213.250"

  # Create audio context
  context = new AudioContext

  class OSC
    constructor: (type, freq, gain=0.25) ->
      @osc = context.createOscillator()
      @gain = context.createGainNode()
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
      @node.gain.linearRampToValueAtTime(peak, context.currentTime + 0.1);
      @node.gain.linearRampToValueAtTime(peak/2, context.currentTime + 0.25);
      @node.gain.linearRampToValueAtTime(0, context.currentTime + (tempo/1000));

  noteToFrequency = (note)->
    note = note - noteFrequencies.length - 1 if note > noteFrequencies.length
    noteFrequencies[note]

  parseIp = (ip)->
    ip.split('.').map (i)->
      parseInt(i)

  impulse = (env, amEnv, fmEnv, tempo)-> 
    env.addEventToQueue(tempo) 
    amEnv.addEventToQueue(tempo, 0.5) 
    fmEnv.addEventToQueue(tempo/2, 50) 

  createVoice = (ipParts)->
    carrier = new OSC("sine", noteToFrequency(ipParts[0]))
    fm = new OSC("sine", noteToFrequency(ipParts[1]), 50)
    am = new OSC("sine", noteToFrequency(ipParts[2]), 0.125)
    tempo = ((ipParts[3]/255) * 19000) + 1000
    am.gain.connect(carrier.osc.gain.gain);
    fm.gain.connect(carrier.osc.frequency);
    env = new Envelope()
    amEnv = new Envelope()
    amEnv.node.connect(am.gain.gain)
    fmEnv = new Envelope()
    fmEnv.node.connect(fm.gain.gain)
    carrier.gain.connect(env.node)
    env.node.connect(context.destination)

    impulse(env, amEnv, fmEnv, tempo)

    setInterval -> 
      impulse(env, amEnv, fmEnv, tempo)
    , tempo

  createVoice(parseIp(ip))
  createVoice(parseIp(ip2))
  createVoice(parseIp(ip3))
  createVoice(parseIp(ip4))
