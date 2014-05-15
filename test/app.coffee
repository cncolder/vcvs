{ cwd, assert } = require './helper'
app = require "#{cwd}/app"

describe 'app', ->
    describe 'view engine', ->
        it 'should be html', ->
            assert.equal app.settings['view engine'], 'html'
            