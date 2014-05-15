_ = require 'underscore'

# jQuery extend
$?.fn.extend
    # CSS visibility helper. Just like .show() and .hide() but hold element position and function.
    visible: ->
        @css 'visibility', ''

    hidden: ->
        @css 'visibility', 'hidden'

    # Change bootstrap state
    state: (state) ->
        states = 'warning error success'.split /\s+/
        
        @each ->
            el = $ @
            if el.is 'input'
                prefix = 'has-'
                formStates = states.map (state) -> "#{prefix}#{state}"
                target = el.parents '.row'
                target.removeClass formStates.join ' '
                target.addClass "#{prefix}#{state}" if state in states

    ###
    Showup.js 
    http://github.com/jonschlinkert/showup
    Jon Schlinkert
    ###
    showUp: (el) ->
        target = $ @
        previous = 0
        calculateLayout = (e) ->
            current = $(e.target).scrollTop()
            if current < Math.max 30, previous
                # Use css3 transition is fast than jQuery animation.
                target.removeClass 'hide'
            else
                target.addClass 'hide'
            previous = current
        $(window).scroll _.debounce calculateLayout, 30

exports.TRANSITION_END = do ->
    browserEventName =
        webkit: 'webkitTransitionEnd'
        # Moz:    'transitionend'
        O:      'oTransitionEnd'
        ms:     'MSTransitionEnd'
    for prefix, eventName of browserEventName when document.body.style["#{prefix}Transition"]?
        return eventName
    'transitionend'

exports.ANIMATION_END = do ->
    browserEventName =
        webkit: 'webkitAnimationEnd'
        # Moz:    'animationend'
        O:      'oAnimationEnd'
        ms:     'MSAnimationEnd'
    for prefix, eventName of browserEventName when document.body.style["#{prefix}Animation"]?
        return eventName
    'animationend'

exports.FULLSCREEN = do ->
    for method in [ 'webkitIsFullScreen', 'mozFullScreen' ] when document[method]?
        return method
    'fullscreen'

exports.REQUEST_FULLSCREEN = do ->
    for method in [ 'webkitRequestFullscreen', 'mozRequestFullScreen' ] when document.body[method]?
        return method
    'requestFullscreen'

exports.FULLSCREEN_CHANGE = do ->
    for prefix in [ 'webkit', 'moz' ] when document["on#{prefix}fullscreenchange"] isnt undefined
        return "#{prefix}fullscreenchange"
    'fullscreenchange'

exports.EXIT_FULLSCREEN = do ->
    for method in [ 'webkitExitFullscreen', 'mozCancelFullScreen' ] when document[method]?
        return method
    'exitFullscreen'
