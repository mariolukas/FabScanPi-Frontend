###
Takes a string and makes it lowercase
Example of a 'common' filter that can be shared by all views
###
name = 'common.filters.currentStateFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('currentState', [
  '$log'
  'fabscan.services.FSScanService'
  ($log, FSScanService) ->

    customFilter = (input) ->

      return ( input is FSScanService.getScannerState() )

    customFilter.$stateful = true
    customFilter
])