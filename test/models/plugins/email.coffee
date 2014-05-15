# { _, vows, assert, async, cwd, mongoose } = require '../../helper'
# { email } = require "#{cwd}/models/plugins"
# 
# schema = new mongoose.Schema
#     name:          
#         type: String
# 
# schema.plugin email
# 
# Foo = mongoose.model 'Foo', schema
# 
# vows
# .describe(email)
# .addBatch
#     teardown: ->
#         Foo.remove {}, @callback
#         return
#         
#     'A model':
#         topic: new Foo
#             email: 'Abc@abc.com'
#         
#         'lowercase email': ({ email }) ->
#             assert.equal email, 'abc@abc.com'
#         
#         'validate':
#             topic: (foo) ->
#                 foo.validate @callback
#         
#             'pass': (err, doc) ->
#                 assert.isNull err
#     
#     'Valid email':
#         topic: ->
#             async.map [
#                 'a@a.us'
#                 'root@localhost'
#                 'Jim.D.Green-J_123+ebay@gmail.com'
#                 'wang@vip.sina.com.cn'
#                 'monkey@acfun.tv'
#             ], (email, callback) ->
#                 foo = new Foo
#                     email: email
#                 foo.validate (err, doc) ->
#                     callback null, err
#             , @callback
# 
#         'be pass': (err, errors) ->
#             assert.ifError err
#             assert.isUndefined err for err in errors
#     
#     'Invalid email':
#         topic: ->
#             async.map [
#                 'a'
#                 'abc-123'
#                 'a@go_go.com'
#                 'a@go.*'
#             ], (email, callback) ->
#                 foo = new Foo
#                     email: email
#                 foo.validate (err, doc) ->
#                     callback null, err
#             , @callback
#         
#         'get many errors': (err, errors) ->
#             assert.ifError err
#             assert.equal err?.errors?.email?.name, 'ValidatorError' for err in errors
#                 
# .export module
