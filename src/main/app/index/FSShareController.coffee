name = "fabscan.controller.FSShareController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  'common.services.toastrWrapperSvc',
  'common.services.Configuration'
  'fabscan.services.FSScanService'
  ($log, $scope, $rootScope, $http, toaster, Configuration, FSScanService) ->

    $scope.stl = null
    $scope.ply = null
    $scope.settings = null
    $scope.id = FSScanService.getScanId()
    $scope.selectedTab = 'download'

    $scope.selectTab  = (tab)->
      $scope.selectedTab = tab


    $log.info $scope.shareDialog
    promise = $http.get(Configuration.installation.httpurl+'api/v1/scans/'+FSScanService.getScanId())
    promise.then (payload) ->
        $log.info payload
        $scope.mesh = payload.data.mesh
        $scope.ply = payload.data.pointcloud
        $scope.settings = payload.data.settings

    $scope.deleteScan = ()->
      $scope.toggleShareDialog()
      promise = $http.get(Configuration.installation.httpurl+'api/v1/delete/'+FSScanService.getScanId())
      promise.then (payload) ->
        $log.info payload.data
        toaster.info('Scan '+FSScanService.getScanId()+ ' deleted')
        FSScanService.setScanId(null)
        $rootScope.$broadcast('clearView')

    $scope.loadPointCloud = (pointcloud) ->
        $scope.toggleShareDialog()
        $scope.scanComplete = false
        toastr.info("Loading file...")
        $scope.loadPLY(pointcloud)

    $scope.runMeshlab = () ->
        $scope.toggleShareDialog()
        FSScanService.runMeshing(FSScanService.getScanId())



])