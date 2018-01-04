name = "fabscan.controller.FSSettingsController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$timeout',
  '$mdDialog',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSScanService'
  ($log, $scope, $rootScope, $timeout, $mdDialog, Configuration ,FSEnumService, FSMessageHandlerService,FSScanService) ->

      $scope.streamUrl = Configuration.installation.httpurl+'stream/laser.mjpeg'

      # TODO: it should be possible to get settings from backend here a function ind FSScanService would be fine...
      $scope.settings = $rootScope.settings
      FSScanService.startSettings()

      $scope.startScan = () ->
        FSScanService.setScanIsComplete(false)
        $scope.showProgressBar = true
        $mdDialog.cancel()
        FSScanService.startScan()

      updateSettings = ->
        _settings = {}
        angular.copy($scope.settings, _settings)
        _settings.resolution *=-1
        FSScanService.updateSettings(_settings)


      $scope.$watch('settings', (newVal, oldVal)->
          if newVal != oldVal
            updateSettings()
      , true)

      $scope.closeDialog = ->
        FSScanService.stopScan()
        $log.debug("Canel pressed")
        $mdDialog.cancel()

])