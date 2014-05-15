process.env.NODE_ENV = 'test'

@[m] = require m for m in 'assert fs path underscore async backbone'.split /\W+/

@cwd = @path.resolve __dirname, '..', '..'
@mongoose = require "#{@cwd}/config/mongoose"
global._ = @_ = @underscore
global.Backbone = @backbone

module.exports = @
