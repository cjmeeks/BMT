var express = require('express');
var app = express();
var pg = require('pg');

// This responds with "Hello World" on the homepage
app.get('/', function (req, res) {
   res.setHeader('Access-Control-Allow-Origin', '*')
   console.log("get from: ", req.url);
   res.writeHead(200, {'Content-Type': 'application/json'})
   res.end("Get Request back")
})


// This responds a POST request for the homepage
app.post('/', function (req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  console.log("Got a POST request");
  req.on('error', function(){
    res.write('Well there was an error somewhere')
    res.end("Error")
  })
  var body = "";
  req.on('data', function(chunk){
    console.log(chunk.toString())
    body+= chunk
  })
  req.on('end', function(){
    console.log("in insert")

    insert(req, res, JSON.parse(body).message, function(err, result){
      res.write(JSON.stringify(result))
      res.end()
    });
  })
})

var server = app.listen(8081, function () {
  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at http://%s:%s", host, port)
})

var insert = function(req,res, message, callback){
  var connection = "postgres://postgres:password@localhost:5432/Test"
  var client = new pg.Client(connection)
  client.connect(function(err){
    if (err) {
         console.log(err);
     }
  })
  //var message = req.body.message
  //client.query("DROP TABLE IF EXISTS test")
  client.query("CREATE TABLE IF NOT EXISTS test (message varchar(64))")
  client.query("INSERT INTO test(message) VALUES($1);", [message], function (err, result)  {
    //console.log(err)
    console.log(result)
    callback(err, result)
  })
}
