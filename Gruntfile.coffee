path = require 'path'
fs = require 'fs'
{ spawn, exec } = require 'child_process'
os = require 'os'
require 'colors'
_ = require 'underscore'
async = require 'async'
moment = require 'moment'
hoganify = require './lib/hoganify'

module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-jshint'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    # grunt.loadNpmTasks 'grunt-manifest'
    
    grunt.initConfig
        env: process.env.NODE_ENV ? 'development'
        tmp: os.tmpdir()
    
        pkg: grunt.file.readJSON 'package.json'
        
        coffee:
            server:
                options:
                    bare: true
                    join: true
                files:
                    'server.js': [
                        '*.coffee', '!Gruntfile.coffee',
                        'config/**/*.coffee', 'lib/**/*.coffee', 'middleware/**/*.coffee',
                        'models/**/*.coffee', 'multiplex/**/*.coffee', 'routes/**/*.coffee'
                    ]
            # server:
            #     expand: true
            #     cwd: ''
            #     src: [ '*.coffee', '!Gruntfile.coffee', 'config/**/*.coffee', 'lib/**/*.coffee', 'middleware/**/*.coffee', 'models/**/*.coffee', 'multiplex/**/*.coffee', 'routes/**/*.coffee' ]
            #     dest: 'build'
            #     ext: '.js'
        
        mocha:
            files: [ 'test/**/*.coffee', '!test/helper' ]
        
        browserify:
            index:
                src: [ 'views/coffee/index.js' ]
                dest: 'public/js/index.js'
                options:
                    transform: [ 'coffeeify', hoganify ]
            # player:
            #     src: [ 'views/coffee/player.js' ]
            #     dest: 'public/js/player.js'
            #     options:
            #         transform: [ 'coffeeify', hoganify ]
        
        jshint:
            index: '<%= browserify.index.dest %>'
        
        uglify:
            options:
                report: 'min'
            index:
                src: '<%= browserify.index.dest %>'
                dest: '<%= browserify.index.dest %>'
            player:
                src: '<%= browserify.player.dest %>'
                dest: '<%= browserify.player.dest %>'
        
        # concat:
        #     options:
        #         separator: ';'
        #         stripBanners: true
        #         banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        #     index:
        #         src: [
        #             # 'views/js/modernizr.min.js'
        #             # 'views/js/jquery-2.0.2.min.js'
        #             # 'views/js/masonry.pkgd.min.js'
        #             # 'views/js/imagesloaded.pkgd.min.js'
        #             'views/js/bootstrap-3.0.0.min.js'
        #             '<%= uglify.index.dest %>'
        #         ]
        #         dest: '<%= uglify.index.dest %>'
        #     
        #     # player:
        #     #     src: [
        #     #         'views/js/modernizr.min.js'
        #     #         'views/js/jquery-2.0.2.min.js'
        #     #         '<%= uglify.player.dest %>'
        #     #     ]
        #     #     dest: '<%= uglify.player.dest %>'
        
        less:
            index:
                options:
                    yuicompress: true
                files: 'public/css/index.css': 'views/less/index.less'
            # player:
            #     options:
            #         yuicompress: true
            #     files: 'public/css/player.css': 'views/less/player.less'
        
        # manifest:
        #     generate:
        #         options:
        #             basePath: 'public/'
        #             cache: [ 'socket.io/socket.io.js' ]
        #             network: [ '*' ]
        #             # fallback: [ '/ /offline.html' ]
        #             # exclude: [ 'crossdomain.xml', 'manifest.appcache', 'robots.txt' ]
        #             preferOnline: true
        #             verbose: false
        #             timestamp: true
        #         src: [
        #             'js/*.js'
        #             'css/*.css'
        #             'fonts/*'
        #             'img/*'
        #         ]
        #         dest: 'public/manifest.appcache'
        
        watch:
            npm:
                files: 'package.json'
                tasks: 'npm'
                
            app:
                files: [
                    'app.coffee', 'server.coffee',
                    'config/*', 'lib/*', 'middlewares/*',
                    'models/**', 'multiplex/*', 'routes/*'
                ]
                tasks: [ 'test', 'server' ]
                options:
                    event: [ 'changed', 'deleted' ]
                    livereload: true
                    nospawn: true
                
            test:
                files: [ '<%= mocha.files %>' ]
                tasks: [ 'test' ]
                options:
                    event: [ 'changed' ]
            
            # html:
            #     files: [ 'views/**/*.html' ]
            #     tasks: [ 'manifest' ]
            #     options:
            #         event: [ 'changed' ]
            #         livereload: true
            
            script:
                files: [
                    'views/coffee/**/*.js',
                    'views/coffee/**/*.coffee',
                    'views/templates/*.html'
                ]
                tasks: [ 'script' ]
                options:
                    event: [ 'changed' ]
                    livereload: true
            
            style:
                files: [ 'views/less/**/*.less' ]
                tasks: [ 'style' ]
                options:
                    event: [ 'changed' ]
                    livereload: true
            
    grunt.registerTask 'console', 'Run coffee repl console.', ->
        require './config/mongoose'
        global[key] = value for key, value of require './models'
        global._c = =>
            grunt.log.writeln
            delete _c[p] for p of _c
            for arg, i in arguments
                if i is 0
                    _c.err = arg 
                else
                    _c["data#{i}"] = arg 
            console.log _c
        require('./node_modules/coffee-script/lib/coffee-script/repl').start().on 'exit', @async()
    
    grunt.registerTask 'server', 'Start express server.', ->
        callback = @async()
        startServer = ->
            global.server = server = spawn 'coffee', [ '-b', 'server.coffee' ],
                stdio: 'inherit'
            # Maybe crash under development.
            server.once 'exit', (code, signal) ->
                grunt.log.oklns "Server exit. pid: #{server.pid}, code: #{code}, signal: #{signal}."
                delete global.server
            grunt.log.oklns "Server spawned. pid: #{server.pid}."
        if global.server?
            { server } = global
            server.once 'exit', (code, signal) ->
                
                startServer()
                callback null
            server.kill 'SIGINT'
        else
            startServer()
            callback null
    
    grunt.registerTask 'bootstrap', 'Start bootstrap jekyll', ->
        jekyll = spawn 'jekyll', [ 'server' ],
            cwd: "#{process.env.HOME}/Documents/Github/bootstrap"
            stdio: 'inherit'
        return
    
    grunt.registerTask 'npm', 'Prune install and dedupe node modules.', ->
        async.series [
            (callback) ->
                spawn 'npm', [ 'prune' ],
                    stdio: 'inherit'
                .once 'close', callback
            (callback) ->
                spawn 'npm', [ 'install' ],
                    stdio: 'inherit'
                .once 'close', callback
        ], @async()
        
    grunt.registerTask 'mocha', 'Mocha test.', ->
        mocha = spawn 'mocha', ['--recursive'],
            stdio: 'inherit'
        mocha.on 'exit', @async()
    
    # grunt.registerTask 'deploy', 'Deploy to joyent, must run on joyent smartmachine.', ->
    #     return unless process.platform is 'sunos'
    #     
    #     cwd = process.cwd()
    #     home = process.env['HOME']
    #     www = path.join home, 'www'
    #     
    #     releases = path.join www, 'releases'
    #     now = moment().format 'YYYYMMDDHHmmss'
    #     target = path.join releases, now
    #     
    #     current = path.join www, 'current'
    #     
    #     node_modules = path.join target, 'node_modules'
    #     shared_node_modules = path.join www, 'node_modules'
    # 
    #     fs.mkdirSync p for p in [ www, releases, shared_node_modules ] when not fs.existsSync p
    #     
    #     async.series [
    #         (callback) ->
    #             spawn 'git', [ 'clone', '-b', 'master', cwd, target ],
    #                 stdio: 'inherit'
    #             .once 'close', callback
    #         (callback) ->
    #             grunt.log.writeln 'Link node_modules'
    #             fs.symlink shared_node_modules, node_modules, 'dir', callback
    #         (callback) ->
    #             spawn 'npm', [ 'prune' ],
    #                 stdio: 'inherit'
    #                 cwd: target
    #             .once 'close', callback
    #         (callback) ->
    #             grunt.log.writeln 'Npm install'
    #             spawn 'npm', [ 'install' ],
    #                 stdio: 'inherit'
    #                 cwd: target
    #             .once 'close', callback
    #         (callback) ->
    #             spawn 'grunt', [ 'build' ],
    #                 stdio: 'inherit'
    #                 cwd: target
    #             .once 'close', callback
    #         (callback) ->
    #             grunt.log.writeln 'Relink current'
    #             if fs.existsSync current
    #                 fs.unlink current, callback
    #             else
    #                 callback null
    #         (callback) ->
    #             fs.symlink target, current, 'dir', callback
    #         (callback) ->
    #             grunt.log.writeln 'Service restart'
    #             spawn 'svcadm', [ 'restart', 'bulletfall' ],
    #                 stdio: 'inherit'
    #             .once 'close', callback
    #     ], @async()
        
    grunt.registerTask 'script', [ 'browserify' ]
    grunt.registerTask 'style', [ 'less' ]
    grunt.registerTask 'test', [ 'mocha' ]
    grunt.registerTask 'build', [ 'browserify', 'uglify', 'concat', 'less' ]
    grunt.registerTask 'release', [ 'npm', 'test', 'build' ]
    
    grunt.registerTask 'dev', [ 'server', 'watch' ] # 'bootstrap'
    grunt.registerTask 'default', [ 'dev' ]
