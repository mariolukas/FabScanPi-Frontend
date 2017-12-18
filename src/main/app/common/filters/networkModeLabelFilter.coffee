###
Takes a string and makes it lowercase
Example of a 'common' filter that can be shared by all views
###
name = 'common.filters.networkModeLabelFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('networkModeLabel', [
  '$log'
  ($log) ->
    (value) ->
      if value
        if value.ap
          return "AP_MODE"
        if value.wired
          return "LAN_MODE"
        if value.wifi
          return "WIFI_MODE"

      return "UNKNOWN"

])