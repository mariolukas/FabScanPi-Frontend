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
    $scope.createScreenShot = null
    $scope.scans = []


    $scope.startScan = () ->
      $scope.stopStream()
      $scope.showSettings = false
      $scope.scanComplete = false
      $scope.scanLoaded = false
      FSScanService.startScan()


    $scope.stopScan = () ->
      $scope.scanComplete = false
      $scope.scanLoaded = false
      $scope.remainingTime = []
      FSScanService.stopScan()


    $scope.toggleShareDialog = () ->
      if $scope.shareDialog
        $scope.shareDialog = false
      else
        $scope.loadDialog = false
        $scope.shareDialog = true


    $scope.toggleLoadDialog =  () ->
      if !$scope.loadDialog
        promise = $http.get(Configuration.installation.httpurl+'api/v1/scans/')
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
      $scope.streamUrl = null


    $scope.manviewhandler = () ->
      if $scope.showSettings
        $scope.exitScanSettings()
      if $scope.shareDialog
        $scope.toggleShareDialog()
      if $scope.loadDialog
        $scope.toggleLoadDialog()


])
