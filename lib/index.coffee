fs = require 'fs'
path = require 'path'
_ = require 'underscore'

module.exports =
    # Require dir tree. Extend to object. The key is lower camel case file name.
    requiredir: (dir, object) ->
        extnames = ['.coffee', '.js', '.json']
    
        for file in fs.readdirSync dir when path.extname(file) in extnames and file isnt path.basename __filename
            file = path.basename file, ext for ext in extnames
      
            try
                mod = require "#{dir}/#{file}"
                name = file.replace /-([a-z])/g, (a, b) -> b.toUpperCase()
                object[name] = mod if object?
            catch ex
                console.error "#{dir}/#{file}", ex
                