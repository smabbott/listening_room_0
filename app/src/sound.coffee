

$ ->
  ip = window.sampleIP

  # Create audio context
  context = new AudioContext

  # createOSC = (hz)->
  #   osc = context.createOscillator()
  #   osc.frequency.value = hz
  #   osc.connect context.destination
  #   osc.start 0 
  #   osc


  class Carrier
    constructor: (type, freq) ->
      @osc = context.createOscillator()
      @gain = context.createGainNode()
      @osc.type = type
      @osc.frequency.value = freq
      @osc.connect(@gain)
      @osc.start(0)

  class Modulator
    constructor: (type, freq, gain) ->
      @osc = context.createOscillator()
      @gain = context.createGainNode()
      @osc.type = type
      @osc.frequency.value = freq
      @gain.gain.value = gain;
      @osc.connect(@gain)
      @osc.start(0)

  noteToFrequency = (note)->
    note = note - noteFrequencies.length - 1 if note > noteFrequencies.length
    noteFrequencies[note]

  # TODO: parse ip into numbers, create notes based on those numbers.
  # numbers could also represet attack, decay, hz, AM, FM, duration, volume...
  ipParts = ip.split('.').map (i)->
    parseInt(i)

  carrier = new Carrier("sine", ipParts[0])
  modulator1 = new Modulator("sine", ipParts[1], 300)
  modulator2 = new Modulator("sine", ipParts[2], 300)
  modulator3 = new Modulator("sine", ipParts[3], 300)
  modulator1.gain.connect(modulator2.osc.frequency);
  modulator2.gain.connect(modulator3.osc.frequency);
  modulator3.gain.connect(carrier.osc.frequency);
  carrier.gain.connect(context.destination);

  # for part in ipParts
  #  createOSC(noteToFrequency[part])

  # osc = createOSC(noteFrequencies[ipParts[0]])
  # setInterval(`function(){cycle()}`, 500)
  # i = 1
  # cycle = ->
  #   console.log i, ipParts[i], noteToFrequency(ipParts[i])
  #   osc.frequency.value = noteToFrequency(ipParts[i])
  #   i++
  #   i = 0 if i == ipParts.length
