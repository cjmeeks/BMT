var express = require('express');
var app = express();
var pg = require('pg');

// This responds with "Hello World" on the homepage
app.get('/', function (req, res) {
   res.setHeader('Access-Control-Allow-Origin', '*')
   console.log("get from: ", req.url);
   res.writeHead(200, {'Content-Type': 'application/json'})
   res.end({data: "data"})
})


// This responds a POST request for the homepage
app.post('/', function (req, res) {
   res.setHeader('Access-Control-Allow-Origin', '*')
   console.log("Got a POST request");
   req.on('error', function(){
    res.write('Well there was an error somewhere')
    res.end("Error")
  })
  console.log("in insert")
  insert(req, res);

  req.pipe(res)
})

var server = app.listen(8081, function () {
  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at http://%s:%s", host, port)
})

var insert = function(req,res){
  console.log('insert')
  var connection = "pg://postgres:postgres@localhost:9000/Test"
  var client = new pg.Client(connection)
  client.connect()
  client.query("DROP TABLE IF EXISTS test")

  client.query("CREATE TABLE IF NOT EXISTS test (message varchar(64))")
  client.query("INSERT INTO test(message), values($1)", ['hello there'])

}
