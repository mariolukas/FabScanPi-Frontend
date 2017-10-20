name = "fabscan.controller.FSConfigController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$timeout',
  '$http',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  ($log, $scope, $timeout, $http, Configuration ,FSEnumService, FSMessageHandlerService) ->

    #$scope.devices = {}

    devices_promise = $http.get(Configuration.installation.httpurl+'api/v1/devices')
    devices_promise.then (payload) ->
      $log.info payload
      $scope.devices = payload.data


    $scope.selectedTab = 'general'

    $scope.selectTab  = (tab)->
      $scope.selectedTab = tab

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


])