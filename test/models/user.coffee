{ assert, cwd } = require '../helper'
{ User } = require "#{cwd}/models"

describe User.modelName, ->
    after (callback) ->
        User.remove {}, callback
    
    it 'has locals', ->
        assert typeof User.locals is 'object'
    
    describe 'new', ->
        user = new User
            name: 'foo'
    
        describe 'password', ->
            user.password = 'a'
        
            it 'has 64 bytes', ->
                assert.equal user.password.length, 64
    
        describe 'email test@test', ->
            user.email = 'test@test'
        
            it 'is valid', (callback) ->
                user.validate callback
    
        describe 'login', ->
            before (callback) ->
                user.login
                    ip: '0.0.0.0'
                    callback
            
            it 'has one activity', ->
                assert.equal user.activities.length, 1
    
    describe 'Save an user without name', ->
        it 'raise validation error', (callback) ->
            new User().save ({ name, errors }) ->
                assert name is 'ValidationError'
                assert errors.name
                assert errors.email
                callback()
