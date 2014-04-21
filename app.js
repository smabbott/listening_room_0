var express = require('express');
var http = require('http');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var routes = require('./routes');
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/listening_room');

var NoteSchema = mongoose.Schema({
  hashedIp:String,
  fundamental:Number,
  aMod:Number,
  fMod:Number,
  tempo:Number,
});

var Note = mongoose.model('Note', NoteSchema);

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(app.router);


// app.get('/', routes.index);

/// catch 404 and forwarding to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.render('error', {
    message: err.message,
    error: {}
  });
});



app.get('/rooms/1', function(req,res){
  var ip = req._remoteAddress
  // if note does not already exist, create it
  Note.count({hashedIp:ip}, function(err, count){
    if(count === 0){
      var note = new Note({hashedIp:ip});
      note.save(function(){
        returnNotes(res);
      });
    }else{
      returnNotes(res);
    }
  });
});

function returnNotes(res){
  Note.find(function(err, notes){
    var ips = notes.map(function(note){return note.hashedIp;});
    res.render('index', {ips:ips});
  });
}


module.exports = app;
