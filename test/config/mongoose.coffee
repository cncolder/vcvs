{ assert, mongoose } = require '../helper'

describe 'mongoose', ->
    it 'is connect to test database', ->
        assert mongoose.connection.name.match /_test$/
