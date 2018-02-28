name = "fabscan.controller.FSToolbarController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$http',
  '$mdDialog',
  '$mdMedia',
  'fabscan.services.FSScanService',
  'fabscan.services.FSEnumService',

  ($log, $scope, $http, $mdDialog, $mdMedia, FSScanService, FSEnumService ) ->


    $scope.circularLoadingMode = 'determinate'

    $scope.$watch (->
      FSScanService.scanProgress
    ), (progress) ->
      # Only in case of loading a scan, because the threejs loader progress is not very acurate.
      if FSScanService.getScannerState() != FSEnumService.states.SCANNING
        if progress >= 80
          $scope.circularLoadingMode = 'intermediate'
        else
          $scope.circularLoadingMode = 'determinate'
        return



    # if small screen and scan is loaded
    $scope.itemLoadedOnSmallScreen = $mdMedia('xs');

    # when button is pressed -> true or screen is big
    $scope.scanItemToolsVisible = $mdMedia('gt-xs');

    $scope.shutdown = ->
      $log.info("Shutdown System")
      FSScanService.shutdownSystem()

    $scope.reboot = ->
      $log.info("Reboot System")
      FSScanService.rebootSystem()

    $scope.restart = ->
      FSScanService.restartServer()

    $scope.showItemTools = ->
      $scope.scanItemToolsVisible = ! $scope.scanItemToolsVisible

    $scope.stopScan = ->
      FSScanService.stopScan()

    $scope.showScanSettingsSheet = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'settings/view/FSSettingsDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: false
      )

    $scope.showGalleryDialog = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'gallery/view/FSGalleryDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true
      )

    $scope.showConfigDialog = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'config/view/FSConfigDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true
      )

])