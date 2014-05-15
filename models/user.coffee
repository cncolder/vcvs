mongoose = require 'mongoose'
{ auth, email, timestamp } = require './plugins'
{ activity } = require './embeds'

locals =
    nameRegex: /// ^ [
        0-9
        a-z
        A-Z
        \u4E00-\u9FFF   # Chinese Japanese Korean
    ]+ $ ///
    membershipEnum: 'admin user'.split /\s+/
    
schema = new mongoose.Schema
    name:          
        type:       String
        required:   true
        unique:     true
        trim:       true
        match:      locals.nameRegex
    membership:    
        type:       String
        enum:       locals.membershipEnum
    activities:    
        type:       [ activity ]

schema.plugin p for p in [ auth, email, timestamp ]

schema.statics.locals = locals

schema.methods.login = ({ ip }, callback) ->
    @activities.push
        ip: ip
    # @activities.shift() until @activities.length <= 10
    @save callback

schema.methods.logout = ({ ip }, callback) ->
    # @activities[0]?.updatedAt = new Date
    @save callback

mongoose.model 'User', schema
