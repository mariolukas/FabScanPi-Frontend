name = "fabscan.controller.FSConfigController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$interval',
  '$http',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  ($log, $scope, $interval, $http, Configuration ,FSEnumService, FSMessageHandlerService) ->

    #$scope.devices = {}
    $scope.wifi_list=[]
    $scope.status = undefined

    #$scope.searchWifiNetworks()

    $scope.showSearchNotification = false
    $scope.showPasswordInputField = false



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
      else
        $interval.cancel $scope.wifi_lookup_interval
        $scope.showPasswordInputField = false
        $scope.showSearchNotification = false

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

          $log.info(device+" "+f_name)

          message = {}
          message =
             event: FSEnumService.events.COMMAND
             data:
                command: FSEnumService.commands.HARDWARE_TEST_FUNCTION
                device:
                  name: device,
                  function: f_name

          FSMessageHandlerService.sendData(message)

    $scope.$on '$destroy', ->
      $interval.cancel  $scope.wifi_lookup_interval
      return

])