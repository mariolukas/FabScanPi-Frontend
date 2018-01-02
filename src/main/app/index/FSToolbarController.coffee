name = "fabscan.controller.FSToolbarController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$http',
  '$mdDialog',
  '$mdMedia',
  ($log, $scope, $http, $mdDialog, $mdMedia ) ->

    # if small screen and scan is loaded
    $scope.itemLoadedOnSmallScreen = $mdMedia('xs');

    # when button is pressed -> true or screen is big
    $scope.scanItemToolsVisible = $mdMedia('gt-xs');

    $scope.showItemTools = ->
      $scope.scanItemToolsVisible = ! $scope.scanItemToolsVisible

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
        clickOutsideToClose: true).then ((answer) ->
            $scope.status = 'You said the information was "' + answer + '".'
        )

    $scope.showConfigDialog = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'config/view/FSConfigDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true).then ((answer) ->
          $scope.status = 'You said the information was "' + answer + '".'
        )

])