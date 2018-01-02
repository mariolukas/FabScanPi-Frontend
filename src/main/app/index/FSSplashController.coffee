name = "fabscan.controller.FSSplashController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$mdDialog',
  'fabscan.services.FSMessageHandlerService',
  ($log, $scope, $mdDialog, FSScanService) ->

      $log.debug("Splash Screen Active")


])