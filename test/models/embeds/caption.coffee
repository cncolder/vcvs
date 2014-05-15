{ cwd, assert, mongoose } = require '../../helper'
{ caption } = require "#{cwd}/models/embeds"

Caption = mongoose.model 'Caption', caption

describe Caption.modelName, ->
    after (callback) ->
        Caption.remove {}, callback
    
    describe 'to vtt node', ->
        caption = new Caption
            text: 'This is a cue.'
            startTime: 109.0234
        
        it 'has virtual start time stamp', ->
            assert.equal caption.startTimestamp, '00:01:49.023'
        
        it 'vtt has time and text', ->
            assert.equal caption.toVTT(), '00:01:49.023 --> 00:01:49.023\nThis is a cue.'
