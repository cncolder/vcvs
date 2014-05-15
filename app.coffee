express = require 'express'

module.exports = app = express()

require('./config').extend app
# require('./routes').extend app
