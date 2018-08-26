name = "fabscan.controller.FSConfigController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$interval',
  '$http',
  '$mdDialog',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSScanService',
  'fabscan.services.FSWebGlService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSDeviceService',
  ($log, $scope, $interval, $http, $mdDialog, Configuration ,FSEnumService, FSScanService, FSWebGlService, FSMessageHandlerService, FSDeviceService) ->

    $scope.wifi_list = []
    $scope.status = undefined
    $scope.config = {}
    $scope.configChanged = false
    $scope.calibrationStarted = false

    $scope.softwareVersion = FSDeviceService.getSoftwareVersion()
    $scope.firmwareVersion = FSDeviceService.getFirmwareVersion()

    $scope.streamUrl = Configuration.installation.httpurl+'stream/adjustment.mjpeg'
    $scope.showStream = true

    FSScanService.getConfig()
    FSScanService.configModeOn()

    $scope.$on(FSEnumService.events.ON_GET_CONFIG, (event, data) ->
      $scope.config = data['config']
      $log.info( data['config'] )
      $scope.$apply()
    )

    $scope.showSearchNotification = false
    $scope.showPasswordInputField = false

    $scope.configUpdateNeeded = () ->
      $scope.configChanged = true

    $scope.updateConfig = (config) ->

      FSScanService.updateConfig(config)
      $scope.configChanged = false
      $log.info("Config updated")

    $scope.getWifiStatus = () ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.NETCONNECT,
          function: "GET_STATUS"
      FSMessageHandlerService.sendData(message)

    $scope.searchWifiNetworks = () ->

      $log.debug("Wifi Interval called")
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.NETCONNECT,
          function: "GET_WIFI_LIST"

      FSMessageHandlerService.sendData(message)
      $scope.showSearchNotification = true

    $scope.$on(FSEnumService.events.ON_NET_CONNECT, (event, data)->
        if data.command == "GET_WIFI_LIST"
          $scope.showSearchNotification = false

          $scope.wifi_list = data['response']

        if data.command == "GET_STATUS"
          $log.debug(data)
          $scope.status = data['response']

        $scope.$apply()
    )

    devices_promise = $http.get(Configuration.installation.httpurl+'api/v1/devices')
    devices_promise.then (payload) ->
      $log.info payload
      $scope.devices = payload.data

    $scope.streamUrl = Configuration.installation.httpurl+'stream/adjustment.mjpeg'
    $scope.selectedTab = 'general'

    $scope.selectTab  = (tab)->
      $scope.selectedTab = tab
      if $scope.selectedTab == "wifi"
        $scope.showPasswordInputField = false
        $scope.getWifiStatus()
        $scope.searchWifiNetworks()
        $scope.wifi_lookup_interval = $interval($scope.searchWifiNetworks, 5000);
      if $scope.selectedTab == 'general'
        #$scope.startStream()
      else
        $interval.cancel $scope.wifi_lookup_interval
        $scope.showPasswordInputField = false
        $scope.showSearchNotification = false
        #$scope.stopStream()

    $scope.selectWifi = (ssid) ->
      $interval.cancel $scope.wifi_lookup_interval
      $scope.showPasswordInputField = true
      $scope.showSearchNotification = false
      $scope.selectedSSID = ssid

    $scope.hidePasswordInput = ->
      $scope.showPasswordInputField = false
      $scope.showSearchNotification = true
      $scope.wifi_lookup_interval = $interval($scope.searchWifiNetworks, 5000);

    $scope.confirmPassword = () ->
      $log.debug("Send Credentials")

    $scope.stopStream = () ->
      $scope.showStream = false
      $scope.streamUrl = ""
      $scope.$apply()

    $scope.startStream = () ->
      $scope.streamUrl = Configuration.installation.httpurl+'stream/adjustment.mjpeg'
      $scope.showStream = true
      $scope.$apply()

    $scope.sendDeviceCommand= (device, f_name) ->

          message = {}
          message =
             event: FSEnumService.events.COMMAND
             data:
                command: FSEnumService.commands.HARDWARE_TEST_FUNCTION
                device:
                  name: device,
                  function: f_name

          FSMessageHandlerService.sendData(message)

    $scope.startCalibration = () ->
      FSWebGlService.clearView()
      FSWebGlService.scansLoaded = false
      FSScanService.startCalibration()
      $mdDialog.cancel()
      $scope.$applyAsync()

    $scope.$on '$destroy', ->
      $interval.cancel  $scope.wifi_lookup_interval
      return

    $scope.closeDialog = ->
      $scope.showStream = false
      $scope.streamUrl = ""
      FSScanService.stopScan()
      $mdDialog.cancel()

])