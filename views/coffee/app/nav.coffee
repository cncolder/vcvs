Backbone = require 'backbone'
User = require '../users/user.coffee'

module.exports = class Nav extends Backbone.View
    constructor: (args) ->
        @el = 'header > nav'
        super args
        
        @ul = @$ 'ul:first'
        
        @$el.showUp()
        
    render: =>    
        @$el.show()
        @
        
    route: =>
        prevli = @ul.find 'li.active'
        nextli = @ul.find "li:has(a[href=\"#{location.pathname}\"])"
        if nextli.length
            prevli.removeClass 'active'
            nextli.addClass 'active'
