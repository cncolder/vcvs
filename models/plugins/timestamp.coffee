module.exports = (schema, options = {}) ->
    { only } = options
    
    if only is 'createdAt' or not only
        schema.add
            createdAt:   
                type:    Date
                default: Date.now
    
    if only is 'updatedAt' or not only
        schema.add
            updatedAt:   
                type:    Date
                default: Date.now

        schema.pre 'save', (next) ->
            @updatedAt = new Date
            next()
