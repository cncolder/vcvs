mongoose = require 'mongoose'
moment = require 'moment'
{ ObjectId } = mongoose.Schema.Types
{ timestamp } = require '../plugins'

typeEnum = 'text lrc'.split /\s+/

module.exports = schema = new mongoose.Schema
    ip:
        type: String
    type:   
        type: String
        enum: typeEnum
        default: 'text'
    startTime:
        type: Number
    text:
        type: String
    user:
        type: ObjectId
        ref: 'User'

schema.plugin timestamp,
    only: 'createdAt'

schema.virtual('startTimestamp').get ->
    moment.utc(@startTime * 1000).format 'HH:mm:ss.SSS'

schema.methods.toVTT = ->
    time = @startTimestamp
    """
        #{time} --> #{time}
        #{@text}
    """