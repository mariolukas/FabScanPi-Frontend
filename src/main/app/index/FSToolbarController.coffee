name = "fabscan.controller.FSToolbarController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$http',
  '$mdDialog',
  '$mdMedia',
  '$mdSidenav',
  'common.services.Configuration',
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService',
  'fabscan.services.FSScanService'
  ($log, $scope, $http, $mdDialog, $mdMedia, $mdSidenav, Configuration, FSEnumService, FSMessageHandlerService, FSScanService) ->



    $scope.topDirections = ['left', 'up'];
    $scope.bottomDirections = ['down', 'right'];

    $scope.isOpen = false;

    $scope.availableModes = ['md-fling', 'md-scale'];
    $scope.selectedMode = 'md-scale';

    $scope.availableDirections = ['up', 'down', 'left', 'right'];
    $scope.selectedDirection = 'up';

    $scope.openSettings = () ->
      $log.info("Yess button pressed.")

    $scope.toggle = (componentId) ->
        $mdSidenav(componentId).toggle()
        return

    $scope.showScanSettingsSheet = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'templates/FSSettingsDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true).then ((answer) ->
        $scope.status = 'You said the information was "' + answer + '".'
        return
      ), ->
      $scope.status = 'You cancelled the dialog.'
      return
      return

])