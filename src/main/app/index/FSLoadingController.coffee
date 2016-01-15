name = "fabscan.controller.FSLoadingController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  'fabscan.services.FSScanService',
  'fabscan.services.FSEnumService'
  ($log, $scope, $rootScope, FSScanService, FSEnum) ->


    $scope.loadPointCloud = (pointcloud, id) ->
        $scope.toggleLoadDialog()
        FSScanService.setScanId(id)
        $scope.scanComplete = false
        toastr.info("Loading Scan "+id)
        $scope.loadPLY(pointcloud)





])