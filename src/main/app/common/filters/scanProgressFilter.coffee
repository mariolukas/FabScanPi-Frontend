###
Takes a string and makes it lowercase
Example of a 'common' filter that can be shared by all views
###
name = 'common.filters.scanProgressFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('scanProgress', [
  '$log'
  'fabscan.services.FSScanService'
  ($log, FSScanService) ->

    customFilter = (input) ->
      return FSScanService.getScanProgress()

    customFilter.$stateful = true
    customFilter
])