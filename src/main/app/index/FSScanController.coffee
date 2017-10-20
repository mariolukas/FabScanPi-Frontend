name = "fabscan.controller.FSScanController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  'ngProgress',
  '$http',
  'common.services.Configuration',
  'fabscan.services.FSEnumService',
  'fabscan.services.FSScanService'
  'fabscan.services.FSMessageHandlerService'
  ($log, $scope, $rootScope, ngProgress, $http, Configuration, FSEnumService,FSScanService, FSMessageHandlerService) ->

    $scope.showSettings = false
    $scope.scanListLoaded = false
    $scope.loadDialog = false
    $scope.shareDialog = false
    $scope.configDialog = false
    $scope.createScreenShot = null
    $scope.scans = []
    $scope.m_filters = []

    $scope.loadFilters = () ->

      filter_promise = $http.get(Configuration.installation.httpurl+'api/v1/filters')
      filter_promise.then (payload) ->
        $log.info payload
        $scope.m_filters = payload.data.filters

        $scope.m_filters.sort (a, b) ->
          x = a.file_name.toLowerCase()
          y = b.file_name.toLowerCase()
          if x < y then -1 else if x > y then 1 else 0

        $scope.selectedFilter = $scope.m_filters[0]['file_name']

    $scope.loadFilters()

    $scope.restartServer = () ->
      FSScanService.restartServer()

    $scope.startCalibration = () ->
      FSScanService.startCalibration()

    $scope.startScan = () ->
      $scope.stopStream()
      $scope.remainingTime = []
      $scope.showSettings = false
      $scope.scanComplete = false
      $scope.scanLoaded = false
      FSScanService.startScan()

    $scope.stopScan = () ->
      $scope.scanComplete = false
      $scope.scanLoaded = false
      $scope.remainingTime = []
      $scope.stopStream()
      FSScanService.stopScan()

    $scope.showConfigDialog = () ->
      $log.info("Open Config Dialog")
      $scope.configDialog = true

    $scope.hideConfigDialog = () ->
      $scope.configDialog = false

    $scope.toggleShareDialog = () ->
      if $scope.shareDialog
        $scope.shareDialog = false
      else
        $scope.loadDialog = false
        $scope.shareDialog = true

    $scope.toggleLoadDialog = () ->
      $scope.displayNews(false)
      if !$scope.loadDialog
        promise = $http.get(Configuration.installation.httpurl+'api/v1/scans')
        promise.then (payload) ->
            $scope.scans = payload.data.scans
            $scope.scanListLoaded = true
            $scope.loadDialog = true
            $scope.shareDialog = false

      else
        $scope.scanListLoaded =false
        $scope.loadDialog = false
        $scope.shareDialog = false


    $scope.exitScanSettings = () ->
      $scope.stopStream()
      $scope.showSettings = false
      $scope.configDialog = false
      #window.stop()
      FSScanService.exitScan()

    $scope.newScan = () ->
      if $scope.loadDialog
        $scope.toggleLoadDialog()
      if $scope.shareDialog
        $scope.toggleShareDialog()
      $scope.showSettings = true
      FSScanService.startSettings()

    $scope.stopStream = () ->
      $scope.streamUrl = " "


    $scope.manviewhandler = () ->
      if $scope.showSettings
        $scope.exitScanSettings()
      if $scope.shareDialog
        $scope.toggleShareDialog()
      if $scope.loadDialog
        $scope.toggleLoadDialog()


])
