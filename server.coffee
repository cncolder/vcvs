#!/usr/bin/env coffee

os = require 'os'
fs = require 'fs'
http = require 'http'
# sio = require 'socket.io'
app = require './app'
pkg = require './package.json'

server = http.createServer app
server.app = app

# io = sio.listen server
# require('./config/socket.io').extend io
# require('./multiplex').extend io

if module.parent?
    module.exports = server
else
    env = process.env.NODE_ENV ?= 'development'
    portMap =
        development:    3000
        test:           3001
        production:     80
    port = process.env.PORT ? portMap[env]
    
    server.listen port, ->
        console.log "Express listening on port #{port}."
