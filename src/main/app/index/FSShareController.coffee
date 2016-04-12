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
    $scope.raw_scans = []
    $scope.meshes = []
    $scope.filters = []

    #$scope.objects = [{type:'ply',name:'raw_scan_0',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0',filter_name:'raw_scan_0',url:'http://irgendwas'}]
    #$scope.filters = [{file_name:'filter_1.mlx',name:'filter_1'},{file_name:'filter_2.mlx',name:'filter_2'},{file_name:'filter_3.mlx',name:'filter_3'}]

    $scope.selectTab  = (tab)->
      $scope.selectedTab = tab

    $scope.nextSubSelection= () ->
      $('.filter-container').slick('slickNext')

    $scope.previewsSubSelection= () ->
      $('.filter-container').slick('slickPrev')



    filter_promise = $http.get(Configuration.installation.httpurl+'api/v1/filters/')
    filter_promise.then (payload) ->
        $log.info payload
        $scope.filters = payload.data.filters

    scan_promise = $http.get(Configuration.installation.httpurl+'api/v1/scans/'+FSScanService.getScanId())
    scan_promise.then (payload) ->
        $log.info payload
        $scope.raw_scans = payload.data.raw_scans
        $scope.meshes = payload.data.meshes

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
        #$scope.previewsSubSelection()
        FSScanService.runMeshing(FSScanService.getScanId())



])