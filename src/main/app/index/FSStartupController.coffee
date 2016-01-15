name = "fabscan.controller.FSStartupController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  'fabscan.services.FSEnumService',
  'fabscan.services.FSScanService'
  'fabscan.services.FSMessageHandlerService'
  ($log, $scope, $rootScope, FSEnumService,FSScanService, FSMessageHandlerService) ->


])