mongoose = require 'mongoose'
database = require './database'

env = process.env.NODE_ENV ? 'development'
url = database[env].url

mongoose.set 'debug', true if env is 'development'
        
mongoose.connect url
        
module.exports = mongoose
