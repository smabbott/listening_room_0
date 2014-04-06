// Generated by CoffeeScript 1.3.3
(function() {

  $(function() {
    var Carrier, Modulator, carrier, context, ip, ipParts, modulator1, modulator2, modulator3, noteToFrequency;
    ip = window.sampleIP;
    context = new AudioContext;
    Carrier = (function() {

      function Carrier(type, freq) {
        this.osc = context.createOscillator();
        this.gain = context.createGainNode();
        this.osc.type = type;
        this.osc.frequency.value = freq;
        this.osc.connect(this.gain);
        this.osc.start(0);
      }

      return Carrier;

    })();
    Modulator = (function() {

      function Modulator(type, freq, gain) {
        this.osc = context.createOscillator();
        this.gain = context.createGainNode();
        this.osc.type = type;
        this.osc.frequency.value = freq;
        this.gain.gain.value = gain;
        this.osc.connect(this.gain);
        this.osc.start(0);
      }

      return Modulator;

    })();
    noteToFrequency = function(note) {
      if (note > noteFrequencies.length) {
        note = note - noteFrequencies.length - 1;
      }
      return noteFrequencies[note];
    };
    ipParts = ip.split('.').map(function(i) {
      return parseInt(i);
    });
    carrier = new Carrier("sine", ipParts[0]);
    modulator1 = new Modulator("sine", ipParts[1], 300);
    modulator2 = new Modulator("sine", ipParts[2], 300);
    modulator3 = new Modulator("sine", ipParts[3], 300);
    modulator1.gain.connect(modulator2.osc.frequency);
    modulator2.gain.connect(modulator3.osc.frequency);
    modulator3.gain.connect(carrier.osc.frequency);
    return carrier.gain.connect(context.destination);
  });

}).call(this);