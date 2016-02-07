name = 'fabscan.controller.FSAppController'

angular.module(name, []).controller(name, [
	'$log',
	'$scope',
  '$http',
  '$rootScope',
  'ngProgress'
  'common.services.toastrWrapperSvc'
  'fabscan.services.FSMessageHandlerService'
  'fabscan.services.FSEnumService'
  'fabscan.services.FSScanService'
	($log, $scope, $http, $rootScope,ngProgress, toastr , FSMessageHandlerService, FSEnumService, FSScanService) ->

    $scope.streamUrl = " "
    $scope.settings = {}
    $scope.scanComplete = false
    $scope.scanLoaded = false
    $scope.remainingTime = []

    $scope.scanDataIsAvailable = ()->
       if FSScanService.getScanId() != null
         return true
       else
         return false

    $scope.$on("CONNECTION", (event, connected) ->
        $log.info("Connected")
        #if not connected
          #FSScanService.setScannerState(undefined)
    )

    $scope.$on(FSEnumService.events.ON_CLIENT_INIT, (event, data) ->
      $log.info "State: "+data['state']
      document.title = "FabScanPi " + data['server_version']
      _settings = data['settings']
      _settings.resolution *=-1
      angular.copy(_settings, $scope.settings)
      FSScanService.setScannerState(data['state'])

      $scope.$apply()
    )

    $scope.$on(FSEnumService.events.ON_STATE_CHANGED, (event, data)->
      $log.info "NEW STATE: "+data['state']
      FSScanService.setScannerState(data['state'])
      $log.info data
      if data['state'] == FSEnumService.states.IDLE
        ngProgress.complete()
      #$scope.$broadcast('refreshSlider');
      $scope.$apply()
    )

    $scope.$on(FSEnumService.events.ON_INFO_MESSAGE, (event, data)->
      toastr.info(data['message'])
      $scope.$apply()
    )


    FSMessageHandlerService.connectToScanner($scope)

])