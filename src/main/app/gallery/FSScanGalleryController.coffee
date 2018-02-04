name = "fabscan.controller.FSScanGalleryController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  '$mdDialog',
  'common.services.Configuration',
  'common.services.FSToasterService',
  'fabscan.services.FSScanService',
  'fabscan.services.FSWebGlService',
  ($log, $scope, $rootScope, $http, $mdDialog, Configuration, toastr, FSScanService, FSWebGlService) ->

    $scope.scans = []
    $scope.galleryIsLoading = true

    promise = $http.get(Configuration.installation.httpurl+'api/v1/scans')
    promise.then ((payload) ->
        $scope.scans = payload.data.scans
        $scope.scansLoaded = true
        $scope.loadDialog = true
        $scope.shareDialog = false
        $scope.galleryIsLoading = false
        $log.info($scope.scans)
        return
      ), (errData) ->
        $scope.closeDialog()
        return


    $scope.scansLoaded=true;

    $scope.loadPointCloud = (pointcloud, id) ->
      FSWebGlService.setScanIsLoading(true)
#        $scope.setScanIsLoading(true)
      FSScanService.setScanIsComplete(false)
#        $scope.setScanIsComplete(false)
      FSScanService.setScanId(id)
      FSScanService.setLoadedFile(pointcloud)
      FSWebGlService.setScanLoaded(false)
      FSWebGlService.loadPLYFile(pointcloud)
      #$scope.loadPLY(pointcloud)
      $scope.closeDialog()
      toastr.info("Loading scanned Pointcloud "+id)


    $scope.deleteScan = (scanID)->
      promise = $http.delete(Configuration.installation.httpurl+'api/v1/scans/'+scanID)
      promise.then (payload) ->
        #toastr.info('Scan '+FSScanService.getScanId()+ ' deleted')
        FSScanService.setScanId(null)
        $rootScope.$broadcast('clearView')
        $scope.closeDialog()

    $scope.loadMesh = (mesh, id) ->
          return

    $scope.closeDialog = ->
      $log.debug("Canel pressed")
      $mdDialog.cancel()
])