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

      #if FSScanService.getScannerState() == FSEnumService.states.UPDATING_SETTINGS
      $scope.streamUrl = Configuration.installation.httpurl+'stream/laser.mjpeg'

      $scope.previewMode = "laser"
      $scope.selectedTab = 'general'

      $log.info($rootScope.settings)
      $scope.settings = $rootScope.settings

      FSScanService.startSettings()

      $scope.startScan = () ->

        FSScanService.setScanIsComplete(false)
        $scope.showProgressBar = true
        $mdDialog.cancel()
        FSScanService.startScan()

      $scope.openBottomSheet = ->
        $mdBottomSheet.show(
          templateUrl: 'templates/fsSettingsMenuTemplate.html',
        ).then(->
          console.log 'You clicked the button to close the bottom sheet!'
          return
        ).catch ->
          console.log 'You hit escape or clicked the backdrop to close.'
          return
        return

      #FSScanService.updateSettings(_settings)
      $scope.timeout = null

      updateSettings = ->

        $log.info("Changed Settinsg")
        _settings = {}
        angular.copy($rootScope.settings, _settings)
        _settings.resolution *=-1
        FSScanService.updateSettings(_settings)

      if $scope.isConnected
        updateSettings()

      $scope.selectTab  = (tab)->
        $scope.selectedTab = tab
        $scope.$broadcast('refreshSlider')
        updateSettings()
        $scope.showLaserPreview()

      $scope.setCalibrationTab = () ->
        $scope.selectedTab = 'calibration'
        $scope.$broadcast('refreshSlider')
        updateSettings()
        $scope.showCalibrationPreview()

      $scope.togglePreviewMode = () ->
        $log.info("Do Nothing")
        if $scope.previewMode == "laser"
          $scope.showCalibrationPreview()
        else
          $scope.showLaserPreview()

      $scope.showCalibrationPreview = () ->
         $scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'
         $scope.previewMode = "calibration"

      $scope.showLaserPreview = () ->
         $scope.streamUrl = Configuration.installation.httpurl+'stream/laser.mjpeg'
         $scope.previewMode = "laser"


      $scope.setColor = () ->
          updateSettings()

      $scope.colorIsSelected = () ->
          if $rootScope.settings.color == "True"
            return true
          else
            return false

      $scope.$watch('settings.resolution', (newVal, oldVal)->
          if newVal != oldVal
            updateSettings()

            $timeout.cancel($scope.timeout);
            $scope.showResolutionValue = true
            $scope.timeout = $timeout((->
              $scope.showResolutionValue = false
              return
            ),  600)

      , true)

      $scope.$watch('settings.laser_positions', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showPositionValue = true
          $scope.timeout = $timeout((->
            $scope.showPositionValue = false
            return
          ),  600)

      , true)

      $scope.$watch('settings.threshold', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showThresholdValue = true
          $scope.timeout = $timeout((->
            $scope.showThresholdValue = false
            return
          ),  200)

      , true)


      $scope.$watch('settings.camera.saturation', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showSaturationValue = true
          $scope.timeout = $timeout((->
            $scope.showSaturationValue = false
            return
          ),  200)

      , true)

      $scope.$watch('settings.camera.contrast', (newVal, oldVal)->
          if newVal != oldVal
            updateSettings()

            $timeout.cancel($scope.timeout);
            $scope.showContrastValue = true
            $scope.timeout = $timeout((->
              $scope.showContrastValue = false
              return
            ),  200)

      , true)


      $scope.$watch('settings.camera.brightness', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showBrightnessValue = true
          $scope.timeout = $timeout((->
            $scope.showBrightnessValue = false
            return
          ),  200)

      , true)

      $scope.$watch('settings.led.red', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showLedRedValue = true
          $scope.timeout = $timeout((->
            $scope.showLedRedValue = false
            return
          ),  200)

      , true)

      $scope.$watch('settings.led.green', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showLedGreenValue = true
          $scope.timeout = $timeout((->
            $scope.showLedGreenValue = false
            return
          ),  200)

      , true)

      $scope.$watch('settings.led.blue', (newVal, oldVal)->
        if newVal != oldVal
          updateSettings()

          $timeout.cancel($scope.timeout);
          $scope.showLedBlueValue = true
          $scope.timeout = $timeout((->
            $scope.showLedBlueValue = false
            return
          ),  200)

      , true)

      $scope.closeDialog = ->
        FSScanService.stopScan()
        $log.debug("Canel pressed")
        $mdDialog.cancel()

])