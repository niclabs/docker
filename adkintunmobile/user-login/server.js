var http = require("http");
var WebSocketServer = require('ws').Server
const uuidV1 = require('uuid/v1');
var winston = require('winston');
var dateFormat = require('dateformat');

var logger = new (winston.Logger)({
  transports: [
    new (winston.transports.File)({
      filename: 'tmp/login-ws-adk.log',
      timestamp: function() {
        return dateFormat(new Date(), "dd-mm-yyyy HH:MM:ss.l");
      },
      formatter: function(options) {
        // Return string will be passed to logger.
        return options.timestamp() +': '+ options.level.toUpperCase() +' -- '+ (options.message ? options.message : '') +
          (options.meta && Object.keys(options.meta).length ? '\n\t'+ JSON.stringify(options.meta) : '' );
      },
      json: false
    })
  ]
});
var ipaddress = "0.0.0.0";
var port = 1234;

var server = http.createServer(function(request, response) {

    response.writeHead(200, {
        "Content-Type": "text/plain",
        "Access-Control-Allow-Origin": "*"
    });


    process.on('uncaughtException', function(err) {
        logger.error("Encountered uncaught Exception: %s", err)
        response.end("Exception");
    });

    try {
        if (request.method == "POST") {
            var url = request.url;
            if (url == "/auth") {

                var body = '';
                request.on('data', function(chunk) {
                    body += chunk.toString();
                    logger.info(body);
                });

                request.on('end', function() {
                    var params = JSON.parse(body);
                    var uuId = params["uuid"];
                    var accessToken = params["access_token"];
                    logger.info(params);
                    logger.info(accessToken);

                    var msg = {
                        'op': 'authdone',
                        'accessToken': accessToken
                    };
                    if (clients[uuId] != undefined || clients[uuId] != null) {
                        clients[uuId].send(JSON.stringify(msg), {
                            mask: false
                        });
                        delete clients[uuId];
                        logger.info("Sending accessToken %s to client with uuid %s", accessToken, uuId);
                        response.end('{"status":"OK"}');
                    } else{
                        logger.info("Received invalid uuid (%s) in /auth", uuId)
                        response.end('{"status":"NOK"}');
                    }
                });
            } else{
              logger.info("Received request for invalid url %s", url);
              response.end('{"status":"NOK"}');
            }
        } else{
          logger.info("Received request with invalid method %s", request.method)
          response.end("NOT Supported");
        }
    } catch (e) {
        logger.error("Caught exception: %s", e)
        response.end("Exception");
    }
}).listen(port, ipaddress);

var wss = new WebSocketServer({
    path: '/gencode',
    server: server,
    autoAcceptConnections: false
});


var clients = {};

wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
        logger.info('Received: %s from client', message);
        var obj = JSON.parse(message);
        if (obj.op == 'hello') {
            var uuidToken = uuidV1();
            clients[uuidToken] = ws;
            var hello = {
                op: 'hello',
                token: uuidToken
            };
            ws.send(JSON.stringify(hello), {
                mask: false
            });
            logger.info('Sent token %s to client', uuidToken);
        }
    });
});

logger.info('Started server');
