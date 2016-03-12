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
  'fabscan.services.FSi18nService'
	($log, $scope, $http, $rootScope,ngProgress, toastr , FSMessageHandlerService, FSEnumService, FSScanService, FSi18nService) ->

    $scope.streamUrl = " "
    $scope.settings = {}
    $scope.scanComplete = false
    $scope.scanLoaded = false
    $scope.remainingTime = []
    $scope.server_version = undefined
    $scope.firmware_version = undefined

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
      $scope.server_version = data['server_version']
      $scope.firmware_version = data['firmware_version']
      _settings = data['settings']
      _settings.resolution *=-1
      angular.copy(_settings, $scope.settings)
      FSScanService.setScannerState(data['state'])
      $log.debug("WebSocket connection ready...")
      #toastr.info(FSi18nService.translateKey('main','CONNECTED_TO_SERVER'))
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

      message = FSi18nService.translateKey('main',data['message'])

      switch data['level']
        when "info" then toastr.info(message,  { timeOut: 5000 })
        when "warn" then toastr.warning(message)
        when "error" then toastr.error(message, { timeOut: 0 })
        when "success" then toastr.success(message)
        else toastr.info(message)

      $scope.$apply()
    )


    FSMessageHandlerService.connectToScanner($scope)

])