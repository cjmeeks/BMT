var http = require('http')
var qs = require('querystring');

var server = http.createServer(function (req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
    if (req.method == 'GET') {
      res.write('"This is a Post"')
    }
  else {
      res.send('req.body')
    }
  res.end()
})

server.listen(3000)
