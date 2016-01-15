basePath = '../../../../target/build';

files = [
  'test/lib/angular/angular.js',
  'test/lib/**/*.js',
  'main/js/*.js',
  'test/js/*.js',
];


browsers = ['Chrome'];

frameworks = ['ng-scenario'];
plugins = ['karma-ng-scenario'];



/* Since we're going to watch using grunt.. */
autoWatch = false;
