#!/usr/bin/env coffee

###
  REQUIRE
###
echo = console.log
{join} = require('path')

gulp = require 'gulp'
runSequence = require 'run-sequence'
browserSync = require 'browser-sync'
markdown = require 'gulp-markdown'
ghpages = require 'gulp-gh-pages'
wrap = require 'gulp-wrap'

###
  PATH
###
srcpath = join __dirname, './src'
dstpath = join __dirname, './dist'

###
  BUILD TASKS
###
gulp.task 'build', ->
  gulp
    .src "#{srcpath}/*.md"
    .pipe wrap """
    <link rel="stylesheet" href="http://jasonm23.github.io/markdown-css-themes/swiss.css">
    <%= contents %>
    """
    .pipe(markdown())
    .pipe browserSync.reload stream:true
    .pipe gulp.dest dstpath

gulp.task 'browsersync', ->
  browserSync
    server:
      baseDir: './'
    port: 9000
    index: 'index.html'
    startPath: 'dist'
    watchTask: true

gulp.task 'watch', ->
  gulp.watch "#{srcpath}/*", ['build']

gulp.task 'default', ->
  runSequence 'build', 'watch', 'browsersync'

gulp.task 'ghpages', ->
  gulp
    .src "#{dstpath}/*"
    .pipe ghpages()
