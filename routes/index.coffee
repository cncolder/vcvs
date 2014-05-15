express = require 'express'
lib = require '../lib'

module.exports = router = express.Router()

router.get '/', (req, res, next) ->
    res.render 'index'

# lib.requiredir __dirname, @

# @extend = (app) ->
    # @css.extend app
    
    # resource method
    # app.resource = (path, obj) ->
    #     path = "/#{path}" if path[0] isnt '/'
    #     if obj.index?
    #         app.get path, obj.index
    #     if obj.range?
    #         app.get "#{path}/:a..:b.:format?", (req, res) ->
    #             a = parseInt req.params.a, 10
    #             b = parseInt req.params.b, 10
    #             format = req.params.format
    #             obj.range req, res, a, b, format
    #     if obj.show?
    #         app.get "#{path}/:id.:format", obj.show
    #         app.get "#{path}/:id", obj.show
    #     if obj.new?
    #         app.get "#{path}/new", obj.new
    #     if obj.create?
    #         app.post "#{path}", obj.create
    #     if obj.update?
    #         app.put "#{path}/:id", obj.update
    #     if obj.destroy?
    #         app.del "#{path}/:id", obj.destroy
        
    
    # app.get '/', (req, res, next) ->
    #     res.render 'index'
            