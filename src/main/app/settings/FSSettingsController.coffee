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
  ($log, $scope, $rootScope, $timeout, $mdDialog, Configuration ,FSEnumService, FSMessageHandlerService, FSScanService) ->

      $scope.streamUrl = Configuration.installation.httpurl+'stream/laser.mjpeg'
      $scope.showStream = true

      FSScanService.startSettings()

      $scope.$on(FSEnumService.events.ON_GET_SETTINGS, (event, data) ->
        $scope.settings = data['settings']
        $scope.$apply()
      )

      $scope.startScan = () ->
        FSScanService.setScanIsComplete(false)
        $scope.showProgressBar = true
        $mdDialog.cancel()
        FSScanService.startScan()

      updateSettings = ->
        _settings = {}
        angular.copy($scope.settings, _settings)
        #_settings.resolution *=-1
        FSScanService.updateSettings(_settings)


      $scope.$watch('settings', (newVal, oldVal)->
          if newVal != oldVal
            updateSettings()
      , true)

      $scope.closeDialog = ->
        $scope.streamUrl = ""
        $scope.showStream = false
        FSScanService.stopScan()
        $log.debug("Canel pressed")
        $mdDialog.cancel()

])