{ SchemaType: { ValidatorError } } = require 'mongoose'

module.exports = (schema, options) ->
    schema.add
        email:      
            type:       String
            required:   true
            unique:     true
            lowercase:  true
            trim:       true
            match:      new RegExp "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
