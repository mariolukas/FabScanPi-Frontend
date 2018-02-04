name = "fabscan.controller.FSMeshingController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$mdDialog',
  'common.services.Configuration'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSScanService'
  ($log, $scope, $mdDialog, Configuration ,FSEnumService, FSMessageHandlerService,FSScanService) ->

    $scope.file_formats = ['ply','stl','obj','off','xyz','x3d','3ds']
    $scope.selectedFormat = $scope.file_formats[0]


    $scope.closeDialog = ->
      FSScanService.stopScan()
      $log.debug("Canel pressed")
      $mdDialog.cancel()

    $scope.runMeshing = () ->
      $scope.toggleShareDialog()
      $log.info $scope.selectedFilter
      $log.info $scope.selectedFormat
      FSScanService.runMeshing(FSScanService.getScanId(), $scope.selectedFilter, $scope.selectedFormat)



])