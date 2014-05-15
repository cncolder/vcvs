{ _, assert, cwd, mongoose } = require '../../helper'
{ auth } = require "#{cwd}/models/plugins"

schema = new mongoose.Schema
    name:          
        type: String

schema.plugin auth

Foo = mongoose.model 'Foo', schema

# vows
# .describe(auth)
# .addBatch
#     teardown: ->
#         Foo.remove {}, @callback
#         return
#         
#     'A model':
#         topic: new Foo
#             name: 'jim'
#             password: 'abc'
#         
#         'has 64 bytes password': ({ password }) ->
#             assert.equal password?.length, 64
#             
#     'There is a saved model.':
#         topic: ->
#             foo = new Foo
#                 name: 'test'
#                 password: 'aBc'
#             foo.save @callback
#             return
#     
#         'Auth not exist name':
#             topic: ->
#                 foo = new Foo
#                     name: 'nobody'
#                 foo.auth @callback
#                 return
#     
#             'got name error': ({ path, type }, foo) ->
#                 assert.equal path, 'name'
#                 assert.equal type, 'exists'
#     
#         'Auth invalid password':
#             topic: ->
#                 foo = new Foo
#                     name: 'test'
#                     password: 'invalidpassword'
#                 foo.auth @callback
#                 return
#     
#             'got password error': ({ path, type }, foo) ->
#                 assert.equal path, 'password'
#                 assert.equal type, 'equal'
#     
#         'Auth right name and password':
#             topic: ->
#                 foo = new Foo
#                     name: 'test'
#                     password: 'aBc'
#                 foo.auth @callback
#                 return
#     
#             'got authed foo': (err, foo) ->
#                 assert.instanceOf foo, Foo
#         
#         'Auth by static method':
#             topic: ->
#                 Foo.auth 'test', 'aBc', @callback
#                 return
#             
#             'got authed foo': (err, foo) ->
#                 assert.instanceOf foo, Foo
#         
#         'Auth lower case password':
#             topic: ->
#                 foo = new Foo
#                     name: 'test'
#                     password: 'abc'
#                 foo.auth @callback
#                 return
#     
#             'got authed foo': (err, foo) ->
#                 assert.instanceOf foo, Foo
#                 
#         'Auth mixed case password':
#             topic: ->
#                 foo = new Foo
#                     name: 'test'
#                     password: 'ABc'
#                 foo.auth @callback
#                 return
#     
#             'got authed foo': (err, foo) ->
#                 assert.instanceOf foo, Foo
#                 
# .export module
