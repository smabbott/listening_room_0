$ ->
  
  context = new AudioContext;
  oscillator = context.createOscillator();
  oscillator.frequency.value = 440;

  oscillator.connect(context.destination);

  oscillator.start(0);