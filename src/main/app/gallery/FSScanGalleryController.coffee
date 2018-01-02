name = "fabscan.controller.FSScanGalleryController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  '$mdDialog',
  'common.services.Configuration',
  'fabscan.services.FSScanService',
  'fabscan.services.FSWebGlService',
  ($log, $scope, $rootScope, $http, $mdDialog, Configuration, FSScanService, FSWebGlService) ->

    $scope.scans = []
    $scope.galleryIsLoading = true

    promise = $http.get(Configuration.installation.httpurl+'api/v1/scans')
    promise.then (payload) ->
      $scope.scans = payload.data.scans
      $scope.scansLoaded = true
      $scope.loadDialog = true
      $scope.shareDialog = false
      $scope.galleryIsLoading = false
      $log.info($scope.scans)

    $scope.scansLoaded=true;

    $scope.loadPointCloud = (pointcloud, id) ->
          FSWebGlService.setScanIsLoading(true)
  #        $scope.setScanIsLoading(true)
          FSScanService.setScanIsComplete(false)
  #        $scope.setScanIsComplete(false)
          FSScanService.setScanId(id)
          FSWebGlService.setScanLoaded(false)
          FSWebGlService.loadPLYFile(pointcloud)
          #$scope.loadPLY(pointcloud)
          $scope.closeDialog()
          toastr.info("Loading scanned Pointcloud "+id)

    $scope.loadMesh = (mesh, id) ->
          return

    $scope.closeDialog = ->
      $log.debug("Canel pressed")
      $mdDialog.cancel()
])