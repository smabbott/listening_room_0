

$ ->
  ip = window.sampleIP

  # Create audio context
  context = new AudioContext

  # Create an oscillator
  # oscillator = context.createOscillator()
  # oscillator.frequency.value = 330

  # hook up the oscillator and start it
  # oscillator.connect context.destination
  # oscillator.start 0

  createOSC = (hz)->
    osc = context.createOscillator()
    osc.frequency.value = hz
    osc.connect context.destination
    osc.start 0 

  # TODO: parse ip into numbers, create notes based on those numbers.
  # numbers could also represet attack, decay, hz, AM, FM, duration, volume...
  ipParts = ip.split('.').map (i)->
    parseInt(i)

  for part in ipParts
    createOSC(noteFrequencies[part])
