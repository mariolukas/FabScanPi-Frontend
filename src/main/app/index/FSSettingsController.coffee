name = "fabscan.controller.FSSettingsController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$timeout',
  '$swipe',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSScanService'
  ($log, $scope, $timeout, $swipe, Configuration ,FSEnumService, FSMessageHandlerService,FSScanService) ->

      #if FSScanService.getScannerState() == FSEnumService.states.UPDATING_SETTINGS
      $scope.streamUrl = Configuration.installation.httpurl+'stream/preview.mjpeg'
      $scope.previewMode = "Webcam"
      $scope.selectedTab = 'general'

      $scope.timeout = null

      updateSettings = ->
        _settings = {}
        angular.copy($scope.settings,_settings)
        _settings.resolution *=-1
        FSScanService.updateSettings(_settings)

      if $scope.isConnected
        updateSettings()

      $scope.selectTab  = (tab)->
        $scope.selectedTab = tab
        $scope.$broadcast('refreshSlider')
        updateSettings()

      $scope.togglePreviewMode = () ->
        $log.info("Do Nothing")
        #if $scope.previewMode == "Threshold"
        #  $scope.showWebcamPreview()
        #else
        #  $scope.showThresholdPreview()

      $scope.showThresholdPreview = () ->
         $scope.streamUrl = Configuration.installation.httpurl+'stream/threshold.mjpeg'
         $scope.previewMode = "Threshold"

      $scope.showWebcamPreview = () ->
         $scope.streamUrl = Configuration.installation.httpurl+'+stream/preview.mjpeg'
         $scope.previewMode = "Webcam"

      $scope.setColor = () ->
          updateSettings()

      $scope.colorIsSelected = () ->
          if $scope.settings.color == "True"
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

])