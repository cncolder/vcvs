path = require 'path'
fs = require 'fs'
express = require 'express'
nowww = require 'connect-no-www'
morgan  = require 'morgan'
mongoose = require './mongoose'
models = require '../models'
router = require '../routes'
# MongoStore = require('connect-mongo') express
consolidate = require 'consolidate'

env = process.env.NODE_ENV ?= 'development'
cwd = path.resolve __dirname, '..'

module.exports = @

@extend = (app) ->
    logger = if env is 'development'
            morgan 'dev'
        else
            morgan 'tiny'
    
    staticPublic = if env is 'production'
            express.static "#{cwd}/public",
                maxAge: 30 * 24 * 60 * 60
        else
            express.static "#{cwd}/public"
        
    # secret = 'Convenience store secret'
    # app.sessionStore = sessionStore = new MongoStore
    #     mongoose_connection: mongoose.connection
    #     stringify: false
    # cookieParser = sessionStore.cookieParser = express.cookieParser secret
    # session = express.session
    #     store: sessionStore
    #     secret: secret
    #     cookie:
    #         maxAge: 30 * 24 * 60 * 60 * 1000
    
    app.set 'env', env
    app.set 'title', 'ViTarn CVS'
    app.set 'views', "#{cwd}/views"
    app.engine 'html', consolidate.hogan
    app.set 'view engine', 'html'
    
    if env is 'production'
        app.enable 'trust proxy'

    # Pay attention the middlewares order.
    # favicon dont need logged.
    # app.use express.favicon()
    app.use logger
    app.use nowww()
    # cookie and session must before body parser
    # app.use cookieParser
    # app.use session
    # decompress before body parser
    # app.use express.compress()
    # app.use express.bodyParser()
    # dynamic before static
    app.use router
    app.use staticPublic
    
    app.set name, locals for name, { locals } of models when locals?
    app.set 'json', JSON.stringify app.locals.settings
