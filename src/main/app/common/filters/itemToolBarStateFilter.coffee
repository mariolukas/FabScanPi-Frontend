name = 'common.filters.itemToolBarStateFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('toolbarVisible', [
  '$log'
  'fabscan.services.FSWebGlService'
  'fabscan.services.FSScanService'
  'fabscan.services.FSEnumService'
  ($log, FSWebGlService, FSScanService, FSEnumService) ->

    customFilter = (input) ->
      return ( FSWebGlService.scanLoaded or FSScanService.scanComplete ) and (FSScanService.getScannerState != FSEnumService.states.CALIBRATING)
      #(FSScanService.getScannerState is not FSEnumService.states.SETTTINGS) and

    customFilter.$stateful = true
    customFilter
])