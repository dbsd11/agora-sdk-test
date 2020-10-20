#!/usr/local/bin/python3.7
#python version 3.7
from http import server
from http.server import SimpleHTTPRequestHandler  
import socket  
import ssl  
import sys
 
 
if sys.argv[1:]:
        port = int(sys.argv[1])
else :
        port = 18080
 
server_address = ("0.0.0.0", port)
 
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
#context.load_cert_chain("xxx.pem","xxx.key")#自己添加
 
httpd = server.HTTPServer(server_address,SimpleHTTPRequestHandler)
httpd.socket = context.wrap_socket(httpd.socket, server_side = True)
httpd.serve_forever()
