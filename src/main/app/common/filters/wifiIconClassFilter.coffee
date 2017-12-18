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
        if value >= -78
          return "wifi-qiality-4"
        if value < -78 and value > -88
          return "wifi-quality-3"
        if value < -89 and value > -95
          return "wifi-quality-2"

        return "wifi-quality-1"

])