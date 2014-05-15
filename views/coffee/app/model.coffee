Backbone = require 'backbone'
io = require '../io.coffee'

# Thanks for moment.js
isoRegex = /^\s*\d{4}-\d\d-\d\d(T(\d\d(:\d\d(:\d\d)?)?)?([\+\-]\d\d:?\d\d)?)?/

class Model extends Backbone.Model
    @connect = (path) ->
        @prototype.socket = io.conn path
    
    constructor: (args) ->
        @idAttribute = '_id'
        
        super args

    parse: (resp, xhr) ->
        for key, value of resp
            resp[key] = date if (isoRegex.test value) and (date = new Date value) and (not isNaN date)
        resp
    
    load: (data) ->
        data = @parse data
        @set data,
            silent: true
    
    silentSet: (args...) ->
        if _.isObject(args[0]) or not args[0]?
            args[1] ?= {}
            args[1].silent = true
        else
            args[2] ?= {}
            args[2].silent = true
        
        @set args...
    
    silentUnset: (args...) ->
        args[1] ?= {}
        args[1].silent = true
        
        @unset args...

    toTemplateJSON: ->
        json = @toJSON()
        
        json.createdMoment = moment @get 'createdAt'
        json.updatedMoment = moment @get 'updatedAt'
    
        json
    
    # Set a hash of model attributes, and sync the model to the server.
    # If the server returns an attributes hash that differs, the model's state will be `set` again.
    save: (callback) ->
        callback 'invalid' unless @isValid()
        method = if @isNew() then 'create' else 'update'
        return callback null, {} if method is 'update' and not @hasChanged()
        
        @sync method, (err, data) =>
            unless err?
                @load data
                @trigger 'sync', @, data
            callback err, data
    
    # Destroy this model on the server if it was already persisted.
    # Optimistically removes the model from its collection, if it has one.
    destroy: (callback) ->
        if @isNew()
            callback null
            @trigger 'destroy', @, @collection
        else
            @sync 'destroy', (err, data) ->
                unless err?
                    @trigger 'destroy', @, @collection
                callback err, data
    
    # Socket.io emit helper.
    # sync 'hi'
    # sync 'save', callback
    # sync 'exists', { name: 'test' }, callback
    sync: (method, rest...) ->
        [ data, callback ] = rest if typeof rest[1] is 'function'
        [ callback ] = rest if typeof rest[0] is 'function'
        callback ?= ->;
        
        data = @changed if method is 'update'
        data ?= @toJSON?() ? {}
        # data.id ?= @id if @id?
        delete data[key] for key in 'createdAt updatedAt'.split /\s+/                
            
        socket = @socket ? @constructor.socket
        socket.emit method, data, callback
        
        return

module.exports = Model
