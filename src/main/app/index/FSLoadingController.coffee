name = "fabscan.controller.FSLoadingController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  'common.services.Configuration',
  'fabscan.services.FSScanService',
  'fabscan.services.FSEnumService'
  ($log, $scope, $rootScope, $http, Configuration, FSScanService, FSEnum) ->

    $scope.scans = []

    promise = $http.get(Configuration.installation.httpurl+'api/v1/scans')
    promise.then (payload) ->
      $scope.scans = payload.data.scans
      $scope.scansLoaded = true
      $scope.loadDialog = true
      $scope.shareDialog = false
      $log.info($scope.scans)

    $scope.slickConfig =
      enabled: true
      autoplay: true
      draggable: false
      arrows: false
      autoplaySpeed: 3000
      slidesToShow: 3
      method: {}
      responsive: [
        {
          breakpoint: 768
          settings:
            slidesToShow: 3
        }
        {
          breakpoint: 480
          settings:
            slidesToShow: 1
        }
      ]

      event:
        beforeChange: (event, slick, currentSlide, nextSlide) ->
        afterChange: (event, slick, currentSlide, nextSlide) ->

    $scope.scansLoaded=true;

    $scope.loadPointCloud = (pointcloud, id) ->
          $scope.setScanIsLoading(true)
          $scope.setScanIsComplete(false)
          $scope.toggleLoadDialog()
          FSScanService.setScanId(id)
          $scope.setScanLoaded(false)

          toastr.info("Loading scanned Pointcloud "+id)
          $scope.loadPLY(pointcloud)

      $scope.loadMesh = (mesh, id) ->
          return


])