name = 'fabscan.controller.FSAppController'

angular.module(name, []).controller(name, [
	'$log',
	'$scope',
  '$rootScope',
  '$timeout',
  '$http',
  '$mdDialog',
  '$mdMedia',
  'common.services.FSToasterService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSEnumService',
  'fabscan.services.FSScanService',
  'fabscan.services.FSi18nService',
	($log, $scope, $rootScope, $timeout, $http, $mdDialog, $mdMedia, toastr,  FSMessageHandlerService, FSEnumService, FSScanService, FSi18nService) ->

    $scope.streamUrl = " "
    #$rootScope.settings = {}

    $scope.remainingTime = []
    $scope.server_version = undefined
    $scope.firmware_version = undefined

    $scope.appIsInitialized = false
    $scope.isCalibrating = false
    $scope.appIsUpgrading = false
    $scope.isConnected = false
    $scope.initError = false

    $scope.showProgressBar= false


    $timeout (->
      $scope.appInitError()
      return
    ), 8000

    $scope.appInitError = () ->
      $scope.initError = true


    $scope.scanDataIsAvailable = ()->
       if $scope.scanLoaded
          $log.info "scan loaded"

       if FSScanService.getScanId() != null
         return true
       else
         return false

    $scope.upgradeServer = () ->
      FSScanService.upgradeServer()


    $scope.$on("CONNECTION_STATE_CHANGED", (event, connected) ->
        $log.info("Connected")
        $scope.isConnected = connected
        if not connected
          $scope.appIsInitialized = false

        $scope.$apply()
    )

    $scope.$on(FSEnumService.events.ON_CLIENT_INIT, (event, data) ->
      $log.info "Initing"
      $scope.remainingTime = []
      $log.info "State: "+data['state']
      document.title = "FabScanPi " + data['server_version']

      $scope.server_version = data['server_version']
      $scope.firmware_version = data['firmware_version']


      if data['upgrade']['available']

        toastr.info 'Click here for upgrade! ', 'Version '+data['upgrade']['version']+' now available', timeOut:0, closeButton:true,  onclick: ->
          $scope.upgradeServer()
          return

      #_settings = data['settings']
      #$log.info("Settings :"+_settings)
      #FSScanService.setStartTime(_settings.startTime)
      #$log.info(_settings.startTime)
      #_settings.resolution *=-1
      #angular.copy(_settings, $rootScope.settings)
      FSScanService.setScannerState(data['state'])
      $scope.appIsUpgrading = data['state'] == FSEnumService.states.UPGRADING
      if data['state'] == FSEnumService.states.IDLE
          $scope.showNewsDialog()
      $log.debug("WebSocket connection ready...")

      #toastr.info(FSi18nService.translateKey('main','CONNECTED_TO_SERVER'))
      $scope.appIsInitialized = true

    )

    # show dialog if news are available...
    $scope.showNewsDialog = (ev) ->
      $mdDialog.show(
        locals:{dataToPass: $scope.loadedNews}
        templateUrl: 'news/view/FSNewsDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true
      )


    $scope.displayNews = (value) ->
      #TODO: Trigger news Dialog here !
      $scope.showNews = value

    $scope.$on(FSEnumService.events.ON_STATE_CHANGED, (event, data)->
      $scope.showNews = false
      $log.info "NEW STATE: "+data['state']
      FSScanService.setScannerState(data['state'])

      if data['state'] == FSEnumService.states.IDLE
          $scope.showProgressBar= false
      if data['state'] == FSEnumService.states.CALIBRATING
        $scope.isCalibrating = true
      else
        $scope.isCalibrating = false

      $scope.$apply()
    )

    $scope.$on(FSEnumService.events.ON_INFO_MESSAGE, (event, data)->

      $log.info(data['message'])
      message = FSi18nService.formatText('main.'+data['message'])
      toastr.show(message, data['level'])
      $scope.$apply()
    )


    FSMessageHandlerService.connectToScanner($scope)

])
