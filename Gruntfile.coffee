module.exports = (grunt)->

	###############################################################
	# Constants
	###############################################################

	PROFILE = grunt.option('profile') || 'dev'

	SRC_DIR =                    'src'
	SRC_TEST_DIR =               "#{SRC_DIR}/test"
	SRC_PROFILES_DIR =           "#{SRC_DIR}/profiles"
	CURRENT_PROFILE_DIR =        "#{SRC_PROFILES_DIR}/#{PROFILE}"

	TARGET_DIR =                 'target'
	GENERATED_DIR =              "#{TARGET_DIR}/generated"
	BUILD_DIR =                  "#{TARGET_DIR}/build"
	BUILD_MAIN_DIR =             "#{BUILD_DIR}/main"

	STAGE_DIR =                  "#{TARGET_DIR}/stage"
	STAGE_APP_DIR =              "#{STAGE_DIR}/app"

	BUILD_TEST_DIR =             "#{BUILD_DIR}/test"

	# index.html is special, since it should be moved out of the index view and into the root
	SRC_INDEX_HTML =             "#{STAGE_APP_DIR}/index/index.html"
	DEST_INDEX_HTML =            "#{BUILD_MAIN_DIR}/index.html"


	PACKAGE =                    grunt.file.readJSON('package.json')

	###############################################################
	# Config
	###############################################################

	grunt.initConfig
		pkg: PACKAGE
		messageformat:
			de:
				locale: 'de',
				inputdir: "#{SRC_DIR}/main/messages/de/"
				output: "#{BUILD_MAIN_DIR}/js/locales/de/i18n.js"
			en:
				locale: 'en',
				inputdir: "#{SRC_DIR}/main/messages/en/"
				output: "#{BUILD_MAIN_DIR}/js/locales/en/i18n.js"

		clean:
			main:
				src: TARGET_DIR

		copy:
			# Copy all non-profile to the stage dir.  Stage dir allows us to override
			# non-profile-specific code w/ the profile defined on the cmd line (or 'dev' by default)
			stage:
				files: [
					{
						expand:        true
						cwd:           "#{SRC_DIR}/main"
						src:           '**'
						dest:          STAGE_DIR
					}
				]

			# override staging dir w/ profile-specific files
			profiles:
				files: [
					 {
						expand:        true
						cwd:           CURRENT_PROFILE_DIR
						src:           '**'
						dest:          STAGE_DIR
					 }
				]

			# copies all files from staging to the build dir that do not need any further processing
			static:
				files: [
					{
						src:           SRC_INDEX_HTML
						dest:          DEST_INDEX_HTML
					}
					{
						src:          "#{STAGE_DIR}/lib/slick/fonts/slick.woff"
						dest:         "#{BUILD_MAIN_DIR}/style/fonts/slick.woff"
					}
					{
						src:          "#{STAGE_DIR}/lib/slick/fonts/slick.ttf"
						dest:         "#{BUILD_MAIN_DIR}/style/fonts/slick.ttf"
					}
          {
            src:          "#{STAGE_DIR}/lib/font-awesome/fonts/fontawesome-webfont.ttf"
            dest:         "#{BUILD_MAIN_DIR}/fonts/fontawesome-webfont.ttf"
          }
          {
              src:          "#{STAGE_DIR}/lib/font-awesome/fonts/fontawesome-webfont.woff"
              dest:         "#{BUILD_MAIN_DIR}/fonts/fontawesome-webfont.woff"
          }
					{
						src:          "#{STAGE_DIR}/lib/font-awesome/fonts/fontawesome-webfont.woff2"
						dest:         "#{BUILD_MAIN_DIR}/fonts/fontawesome-webfont.woff2"
					}
					{
						expand:        true
						cwd:           STAGE_APP_DIR
						src:           ['**/*.{html,jpg,png,gif,json,txt,svg}', '!**/index/**']
						dest:          BUILD_MAIN_DIR
					}
				]

			test:
				files: [
					{
						expand:        true
						cwd:           SRC_TEST_DIR
						src:           ['{lib,config}/**']
						dest:          BUILD_TEST_DIR
					}
				]

		mkdir:
			generate:
				options:
					create: ["#{GENERATED_DIR}"]

		generate:
			version:
				values:
					version: PACKAGE.version
					buildNumber: process.env.BUILD_NUMBER
					buildDate: new Date().toISOString()
					revision: process.env.MERCURIAL_REVISION
				dest: "#{GENERATED_DIR}/version.coffee"

		concat:
			app_css:
				src: "#{STAGE_APP_DIR}/**/*.css"
				dest: "#{BUILD_MAIN_DIR}/style/app.css"
			lib_css:
				src: "#{STAGE_DIR}/lib/**/*.css"
				dest: "#{BUILD_MAIN_DIR}/style/lib.css"
			lib_js:
				src: [
            "#{STAGE_DIR}/lib/jquery/jquery-1.11.1.js",
            "#{STAGE_DIR}/lib/angular/angular.js",
						"#{STAGE_DIR}/lib/threejs/angular-material.js",
						"#{STAGE_DIR}/lib/slick/slick.js",
						"#{STAGE_DIR}/lib/angular-slick/slick.js",
            "#{STAGE_DIR}/lib/threejs/three.js",
            "#{STAGE_DIR}/lib/threejs/TrackballControls.js",
            "#{STAGE_DIR}/lib/**/*.js"

        ]
				dest: "#{BUILD_MAIN_DIR}/js/lib.js"
			lib_test_js:
				src: [
					"#{SRC_TEST_DIR}/lib/jquery/*.js",
					"#{SRC_TEST_DIR}/lib/angular/angular.js",
					"#{SRC_TEST_DIR}/lib/**/*.js"
				]
				dest: "#{BUILD_TEST_DIR}/js/lib.js"

		coffee:
			app:
				src: [
					"#{STAGE_APP_DIR}/**/*.coffee"
					"#{GENERATED_DIR}/*.coffee"
				]
				dest: "#{BUILD_MAIN_DIR}/js/app.js"
			test:
				src: "#{SRC_TEST_DIR}/**/*.coffee"
				dest: "#{BUILD_TEST_DIR}/js/tests.js"

		uglify:
			lib_js:
				src: "#{BUILD_MAIN_DIR}/js/lib.js"
				dest: "#{BUILD_MAIN_DIR}/js/lib.js"
			app_js:
				src: "#{BUILD_MAIN_DIR}/js/app.js"
				dest: "#{BUILD_MAIN_DIR}/js/app.js"

		cssmin:
			lib_css:
				src: "#{BUILD_MAIN_DIR}/style/lib.css"
				dest: "#{BUILD_MAIN_DIR}/style/lib.css"
			app_css:
				src: "#{BUILD_MAIN_DIR}/style/app.css"
				dest: "#{BUILD_MAIN_DIR}/style/app.css"

		connect:
			server:
				options:
          port: 8001
          hostname: "0.0.0.0"
					base: "#{BUILD_MAIN_DIR}/target/build/main"


		karma:
			unit:
				configFile: "#{BUILD_TEST_DIR}/config/unit.conf.js"
				background: true
			watch:
				configFile: "#{BUILD_TEST_DIR}/config/watch.conf.js"
				background: true
			ci:
				configFile: "#{BUILD_TEST_DIR}/config/ci.conf.js"
				background: false
				singleRun: true

		watch:
			build:
				files: ["#{SRC_DIR}/**/*.{css,coffee,js,svg,html}", "!{SRC_INDEX_HTML}"]
				tasks: ['build']
			karma:
				options:
					debounceDelay: 1000
					#frameworks: ['jasmine']
				files: ["#{BUILD_TEST_DIR}/js/*.js","target/build/main/js/*.js"]
				tasks: ['karma:watch:run']


	##############################################################
	# Dependencies
	###############################################################
	#grunt.loadNpmTasks('karma-coverage')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-contrib-concat')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-cssmin')
	grunt.loadNpmTasks('grunt-contrib-connect')
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-messageformat')
	grunt.loadNpmTasks('grunt-karma')
	grunt.loadNpmTasks('grunt-mkdir')

	grunt.loadTasks('grunt-tasks')


	###############################################################
	# Alias tasks
	###############################################################



	grunt.registerTask('generate', ['mkdir', 'messageformat'])

	grunt.registerTask('build', ['copy','generate','concat','coffee'])
	grunt.registerTask('tests', ['karma:watch'])
	grunt.registerTask('watcher', ['connect','tests','watch'])
	grunt.registerTask('dist', ['build','uglify','cssmin'])

	grunt.registerTask('ci', ['clean','build','karma:ci'])
	grunt.registerTask('default', ['clean','build','karma:watch','watcher',])



