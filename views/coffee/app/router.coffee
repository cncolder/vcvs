Backbone = require 'backbone'
Nav = require './nav.coffee'
UserNav = require '../users/user-nav.coffee'
LoginModal = require '../users/login-modal.coffee'
PostModal = require '../videos/post-modal.coffee'
Waterfall = require '../videos/waterfall.coffee'

module.exports = class Router extends Backbone.Router
    constructor: (args) ->
        @routes =
            '':                 'index'
            
            'videos':           'videos'
            'videos/popular':   'popular'
            'videos/fresh':     'fresh'
            
            'about':            'about'
            
            'users/logout':     'logout'
        
        super args

        @nav = new Nav
        @userNav = new UserNav
        @loginModal = new LoginModal
        @postModal = new PostModal
        @waterfall = new Waterfall
        
        @nav.render()
        @on 'route', @nav.route
        @userNav.render()
        @loginModal.on 'login', (user) =>
            @userNav.login user
        
        @loginModal.hide()

        Backbone.history.start
            pushState: true

        # Prevent internal link click, trigger backbone navigate event.
        # Exclude other site link, new window link and bootstrap toggle link.
        $(document).on 'click', 'header nav a:not([href^=http],[target],[data-toggle])', (e) =>
            e.preventDefault()
            href = $(e.target).attr 'href'
            @navigate href, true
    
    index: ->
        @videos()
    
    videos: ->
        @waterfall.index()
        
    popular: ->
    
    about: ->
    
    login: ->
        @loginModal.render()
    
    logout: ->
        @userNav.logout (err, data) =>
            if err?
            else
                @navigate '/', true
    
    post: ->
        @postModal.render()
