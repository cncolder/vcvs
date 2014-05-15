{ SchemaType: { ValidatorError } } = require 'mongoose'
crypto = require 'crypto'

sha2560 = (s) ->
    for i in [ 1..10 ]
        s = crypto.createHash('sha256').update(s).digest 'hex'
    s

module.exports = (schema, options) ->
    schema.add
        password:      
            type:      String
            lowercase: true
            trim:      true
            match:      /^[\da-f]{64}$/
            select:    false
            set:       (value) ->
                if value?.length then sha2560 value.toLowerCase() else undefined
    
    schema.methods.auth = (callback) ->
        { name, password } = @
        
        @constructor.findOne
            name: name
            '+password'
            (err, doc) ->
                return callback new ValidatorError 'name', 'exists' if not doc?
                return callback new ValidatorError 'password', 'equal' if doc.password isnt password
                callback err, doc

    schema.statics.auth = (name, password, callback) ->
        model = new @
            name:     name
            password: password
        
        model.auth callback
