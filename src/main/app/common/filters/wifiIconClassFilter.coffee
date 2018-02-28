###
Takes a string and makes it lowercase
Example of a 'common' filter that can be shared by all views
###
name = 'common.filters.wifiIconClassFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('wifiIconClass', [
  '$log'
  ($log) ->
    (value) ->
        if value <= -55
          return "wifi-qiality-4"
        if value >= -54 and value <= -45
          return "wifi-quality-3"
        if value >= -46 and value <= -35
          return "wifi-quality-2"
        if value >=-36
          return "wifi-quality-1"


])