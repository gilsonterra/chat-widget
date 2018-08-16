var gulp = require('gulp');
var minifier = require('gulp-minifier');
var clean = require('gulp-clean');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var riot = require('gulp-riot');
var runSequence = require('run-sequence');
var ext_replace = require('gulp-ext-replace');

gulp.task('clean', function () {
    return gulp.src([
        'build/'
    ], {
        read: false
    }).pipe(clean({
        force: true
    }));
});

gulp.task('js', function () {
    return gulp.src([
            'node_modules/riot/riot.min.js',
            'tags-compile/*',
            'js/*'          
        ])
        .pipe(minifier({
            minify: true,
            minifyJS: true,
            collapseWhitespace: true
        }))
        .pipe(concat('scripts.min.js'))
        .pipe(gulp.dest('build/'));
});

gulp.task('tags', function () {
    return gulp.src([
            'tags/**/*.tag'
        ])
        .pipe(riot({
            compact: true,
        }))
        .pipe(ext_replace('.js'))
        .pipe(gulp.dest('tags-compile'));
});

gulp.task('default', function () {
    runSequence('clean', 'tags', 'js');
});