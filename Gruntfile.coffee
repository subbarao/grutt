module.exports = (grunt) ->
  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        sourceMap: true
      alloyctrls:
        files: [
          expand: true
          cwd: 'ti/src/lib'
          src: [ '**/*.coffee' ]
          dest: 'ti/app/lib'
          ext: '.js'
        ]
        options:
          bare: true
      alloylib:
        files: [
          expand: true
          cwd: 'ti/src/controllers'
          src: [ '**/*.coffee' ]
          dest: 'ti/app/controllers'
          ext: '.js'
        ]
        options:
          bare: false
      test:
        files: [
          expand: true
          cwd: 'ti/tests/'
          src: [ '**/*.coffee' ]
          dest: 'ti/spec/'
          ext: '.js'
        ]
        options:
          bare: false

    jade:
      alloy:
        files: [
          expand: true
          cwd: 'ti/src/'
          src: [ '**/*.jade' ]
          dest: 'ti/app/'
          ext: '.xml'
        ]

    ltss:
      alloy:
        files: [
          expand: true
          cwd: 'ti/src/'
          src: [ '**/*.ltss' ]
          dest: 'ti/app/'
          ext: '.tss'
        ]

    copy:
      alloy:
        files: [
          expand: true
          dot: true
          cwd: 'ti/src/'
          dest: 'ti/app/'
          src: [
            '**'
            '!**/*.coffee'
            '!**/*.jade'
            '!**/*.ltss'
          ]
        ]

    tishadow:
      options:
        projectDir: 'ti/'
        update: true
        withAlloy: true
      run:
        command: 'run'
        options:
          alloy:
            platform: [ 'ios' ]
      test:
        command: 'spec'
        options:
          alloy:
            platform: [ 'ios' ]
      clear:
        command: 'clear'
        options:
          alloy:
            platform: [ 'ios' ]

    watch:
      options:
        spawn: false
      alloy:
        files: [ 'ti/src/**/*' ]
        tasks: [
          'build:ti'
          'tishadow:run'
        ]
      test:
        files: [ 'ti/src/**/*', 'ti/tests/**/*' ]
        tasks: [ 'execute:test' ]

    clean:
      ti: [
        'ti/Resources/'
        'ti/app/'
        'ti/build/'
        'ti/spec/'
      ]


  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'build', [
    'build:ti'
  ]

  grunt.registerTask 'build:ti', [
    'coffee:alloyctrls'
    'coffee:alloylib'
    'jade:alloy'
    'ltss:alloy'
    'copy:alloy'
  ]
  grunt.registerTask 'execute:test', [
    'tishadow:clear'
    'clean'
    'build:ti'
    'coffee:test'
    'tishadow:test'
  ]

  grunt.registerTask 'dev', [
    'build:ti'
    'tishadow:run'
    'watch:alloy'
  ]

  grunt.registerTask 'test', [
    'execute:test'
    'watch:test'
  ]
