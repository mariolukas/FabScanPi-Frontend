
name = 'common.filters.toResolutionValue'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('toResolutionValue', [
  '$log'
  ($log) ->
    (str) ->
      if str == -1
        return "best about 120 seconds"

      if str == -4
        return "good about 60 seconds"

      if str == -8
        return "medium 30 seconds"

      if str == -12
        return "low about 20 seconds"

      if str == -16
        return "lowest about 10 seconds"


])