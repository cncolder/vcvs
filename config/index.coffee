require '../lib/regexp'

module.exports = @

@extend = (app) ->
    require('./express').extend app
    