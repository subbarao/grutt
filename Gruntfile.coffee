module.exports = (grunt) ->
  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    name: 'titanium-app'

    coffee:
      options:
        sourceMap: true
      alloyctrls:
        files: [
          expand: true
          cwd: '<%= name %>/src/lib'
          src: [ '**/*.coffee' ]
          dest: '<%= name %>/app/lib'
          ext: '.js'
        ]
        options:
          bare: true
      alloylib:
        files: [
          expand: true
          cwd: '<%= name %>/src/controllers'
          src: [ '**/*.coffee' ]
          dest: '<%= name %>/app/controllers'
          ext: '.js'
        ]
        options:
          bare: false
      test:
        files: [
          expand: true
          cwd: '<%= name %>/tests/'
          src: [ '**/*.coffee' ]
          dest: '<%= name %>/spec/'
          ext: '.js'
        ]
        options:
          bare: false

    jade:
      alloy:
        files: [
          expand: true
          cwd: '<%= name %>/src/'
          src: [ '**/*.jade' ]
          dest: '<%= name %>/app/'
          ext: '.xml'
        ]

    ltss:
      alloy:
        files: [
          expand: true
          cwd: '<%= name %>/src/'
          src: [ '**/*.ltss' ]
          dest: '<%= name %>/app/'
          ext: '.tss'
        ]

    copy:
      alloy:
        files: [
          expand: true
          dot: true
          cwd: '<%= name %>/src/'
          dest: '<%= name %>/app/'
          src: [
            '**'
            '!**/*.coffee'
            '!**/*.jade'
            '!**/*.ltss'
          ]
        ]

    tishadow:
      options:
        projectDir: '<%= name %>/'
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
        files: [ '<%= name %>/src/**/*' ]
        tasks: [
          'build:ti'
          'tishadow:run'
        ]
      test:
        files: [ '<%= name %>/src/**/*', '<%= name %>/tests/**/*' ]
        tasks: [ 'execute:test' ]

    clean:
      ti: [
        '<%= name %>/Resources/'
        '<%= name %>/app/'
        '<%= name %>/build/'
        '<%= name %>/spec/'
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
