Backbone = require 'backbone'

class Collection extends Backbone.Collection
    parse: (resp, xhr) ->
        @model.prototype.parse json, xhr for json in resp
    
    fetch: (rest...) ->
        [ conditions, options, callback ] = rest if typeof rest[2] is 'function'
        [ conditions, callback ] = rest if typeof rest[1] is 'function'
        [ callback ] = rest if typeof rest[0] is 'function'
        conditions ?= {}
        options ?= {}
        callback ?= ->;
        options.parse ?= @parse
        @sync 'read', conditions, (err, data) =>
            if err? or not data?
                callback err, data
            else
                method = if options.reset then 'reset' else 'set'
                @[method] data, options
                callback err, data
                # @triger 'sync', @, data, options
                
    # Socket.io emit helper.
    # sync 'hi'
    # sync 'read', callback
    # sync 'exists', { name: 'test' }, callback
    sync: (method, rest...) ->
        [ data, callback ] = rest if typeof rest[1] is 'function'
        [ callback ] = rest if typeof rest[0] is 'function'
        callback ?= ->;

        socket = @model.prototype.socket
        socket.emit method, data, callback

        return
        
module.exports = Collection
