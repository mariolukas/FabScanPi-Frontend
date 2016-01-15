###
Takes a string and makes it lowercase
Example of a 'common' filter that can be shared by all views
###
name = 'common.filters.scanDataAvailableFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('scanDataAvailable', [
  '$log'
  'fabscan.services.FSScanService'
  ($log, FSScanService) ->
    () ->
      if FSScanService.getScanId() != null
        return true
      else
        return false

])