# { _, vows, assert, cwd, mongoose, async } = require '../../helper'
# { timestamp } = require "#{cwd}/models/plugins"
# 
# schema = new mongoose.Schema
# schema.plugin timestamp
# Foo = mongoose.model 'Foo', schema
# 
# schemac = new mongoose.Schema
# schemac.plugin timestamp,
#     only: 'createdAt'
# Fooc = mongoose.model 'Fooc', schemac
# 
# schemau = new mongoose.Schema
# schemau.plugin timestamp,
#     only: 'updatedAt'
# Foou = mongoose.model 'Foou', schemau
# 
# vows
# .describe(timestamp)
# .addBatch
#     teardown: ->
#         async.parallel [
#             (callback) -> Foo.remove {}, callback
#             (callback) -> Fooc.remove {}, callback
#             (callback) -> Foou.remove {}, callback
#         ], @callback
#         return
#         
#     'A model with timestamp plugin':
#         topic: new Foo
#         
#         'has createdAt/updatedAt attributes': ({ createdAt, updatedAt }) ->
#             now = new Date
#             
#             for stamp in [ createdAt, updatedAt ]
#                 assert.instanceOf stamp, Date
#                 assert now - stamp < 99
#         
#         'save later':
#             topic: (foo) ->
#                 _.delay (=>
#                     foo.save @callback), 99
#                 return
#             
#             'updatedAt is ahead createdAt': (err, { createdAt, updatedAt }) ->
#                 assert updatedAt - createdAt > 99
#     
#     'A model with createdAt':
#         topic: new Fooc
#         
#         'only has create time stamp': (fooc) ->
#             assert.instanceOf fooc.createdAt, Date
#             assert.isUndefined fooc.updatedAt
#         
#     'A model with updatedAt':
#         topic: new Foou
#         
#         'only has update time stamp': (foou) ->
#             assert.instanceOf foou.updatedAt, Date
#             assert.isUndefined foou.createdAt
#                 
# .export module
