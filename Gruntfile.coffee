module.exports = (grunt)->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    coffee:
      compile:
        files:
          "lib/simditor-video.js":"src/simditor-video.coffee"
    sass:
        dist:
        	file:
          		'lib/simditor.css': 'src/simditor.scss'
          	options:
          		sourcemap: 'false'
  )
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.registerTask 'default', ['coffee:compile']