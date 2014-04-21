// Generated by CoffeeScript 1.3.3
(function() {

  window.IPParser = {
    parseIP: function(ip) {
      var parts;
      return parts = ip.split('.').map(function(i) {
        return IPParser.parseNum(i);
      });
    },
    parseNum: function(num) {
      return IPParser.pad(parseInt(num).toString(2), 8);
    },
    pad: function(s, l) {
      var gap;
      gap = l - s.length + 1;
      while (gap -= 1) {
        s = "0" + s;
      }
      return s;
    }
  };

  $(function() {
    var animateCounter, digit, generateDigit, ip, ipBase10, part, toBoolean, _i, _len, _results;
    ip = window.sampleIP || '192.168.1.50';
    toBoolean = function(b) {
      return b === '1' || b === 1;
    };
    generateDigit = function(num, digit) {
      var bit, box, _i, _results;
      _results = [];
      for (bit = _i = 0; _i <= 7; bit = ++_i) {
        box = $("<div class='box'></div>");
        if (toBoolean(num[bit])) {
          box.addClass('on');
        }
        _results.push(digit.append(box));
      }
      return _results;
    };
    ipBase10 = ip.split('.').map(function(i) {
      return parseInt(i);
    });
    animateCounter = function(counterWrapper, target) {
      var count, counter, counterInterval;
      counter = 0;
      counterInterval = setInterval(function(){count()}, 10);
      return count = function() {
        counterWrapper.empty();
        generateDigit(IPParser.parseNum(counter), counterWrapper);
        if (counter === target) {
          clearInterval(counterInterval);
        }
        return counter++;
      };
    };
    _results = [];
    for (_i = 0, _len = ipBase10.length; _i < _len; _i++) {
      part = ipBase10[_i];
      digit = $("<div class='digit'></div>");
      $('.container').append(digit);
      _results.push(animateCounter(digit, part));
    }
    return _results;
  });

}).call(this);
