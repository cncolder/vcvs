path = require 'path'
hogan = require 'hogan.js'
cwd = path.resolve __dirname, '..'
through = require "#{cwd}/node_modules/coffeeify/node_modules/through"

###
Compile mustache template to js with hogan. Use by browserify transform.
Browserify need js entry point. So the best way is require template.html in a coffee then exports them.
At this time must put hoganify after coffeeify.

eg:

# ./app.coffee
browserify.settings
    transform:  [ 'coffeeify', hoganify ]

# ./views/coffee/template.coffee
module.exports =
    user: require '../templates/user.html'

# ./views/templates/user.html
Hello {{ name }}!

# ./views/coffee/index.js
templates = require './templates'
console.log templates.user
#> [Function]
hogan = require 'hogan.js'
usertpl = new hogan.Template templates.user
usertpl.render
    name: 'YI'
#> Hello YI!
###
module.exports = (file) ->
    return through() unless /\.html$/.test file
    data = ''
    through (buf) ->
        data += buf
    , ->
        try
            tpl = hogan.compile data,
                asString: true
            tpl = "module.exports= #{tpl}"
            @queue tpl
            @queue null
        catch ex
            @emit 'error', ex