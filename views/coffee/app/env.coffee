module.exports = ->
    env = $('meta[name="generator"]')?.prop('content')?.split(/\s+/)[1]
    env ? 'development'
