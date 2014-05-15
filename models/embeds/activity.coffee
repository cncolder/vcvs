mongoose = require 'mongoose'
{ timestamp } = require '../plugins'

module.exports = schema = new mongoose.Schema
    ip:
        type: String

schema.plugin timestamp,
    only: 'createdAt'
