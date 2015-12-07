module.exports = function (grunt) {
	
	grunt.initConfig({

		concat: {
			options: {
				separator: ';',
			},
			dist: {
				src: [	'bin/sl/jquery-1.11.3.min.js',
					  	'bin/sl/Screenfull.js',
					  	'bin/sl/Slideshow.js'
					 ],
				dest: 'www/sl/sl.min.js'
			},
		},
		
		uglify: {
			options: {
				mangle: true
			},
			dist: {
				files: {
					'www/sl/sl.min.js': 'www/sl/sl.min.js'
				}
			}
		},

		// CONCAT & MINIFY
		cssmin: {
			options: {
				shorthandCompacting: true,
				roundingPrecision: -1
			},
			dist: {
				files: {
					'www/sl/sl.min.css': [ 'bin/sl/slStyle.css' ]
				}
			}
		},
		
		// ADD VENDOR
		postcss: {
			options: {
				map: false,
				//map: true, // inline sourcemaps

				// or
				/*map: {
					inline: false, // save all sourcemaps as separate files...
					annotation: dir+'css/prefix/' // ...to the specified directory
				},*/

				processors: [
					require('autoprefixer-core')({
									browsers: 'last 2 versions'
								}), // add vendor prefixes
					//require('cssnano')() // minify the result
				  ]
			},
			dist: {
				src: ['www/sl/sl.min.css']
			}
		},
		
		// AUTOMATIC REFRESH
		watch: {
			scripts: {
				files: ['bin/sl/*.js', 'bin/sl/*.css'],
				tasks: ['default'],
				options: {
					spawn: false,
				},
			},
		},

	});

	grunt.loadNpmTasks('grunt-contrib-concat');
	//grunt.loadNpmTasks('autoprefixer-core');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-postcss');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-contrib-compress');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask('default', [ 'concat:dist', 'uglify:dist', /*'jshint:all', 'uglify:dist',*/ 'cssmin:dist', 'postcss:dist'/*, 'compress'*/]);
};