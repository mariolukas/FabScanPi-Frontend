name = "fabscan.controller.FSToolsController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  '$mdDialog'
  '$mdMedia'
  'common.services.FSToasterService',
  'common.services.Configuration',
  'fabscan.services.FSScanService',
  'fabscan.services.FSWebGlService',
  'fabscan.services.FSEnumService',
  ($log, $scope, $rootScope, $http, $mdDialog, $mdMedia, toaster, Configuration, FSScanService, FSWebGlService, FSEnumService) ->

    $scope.settings = null
    $scope.id = FSScanService.getScanId()

    $scope.raw_scans = []
    $scope.meshes = []
    $scope.loadedFile = FSScanService.getLoadedFile()


    $scope.showMeshingDialog = (ev) ->
      $mdDialog.show(
        #controller: DialogController
        templateUrl: 'tools/views/FSMeshingDialog.tpl.html'
        parent: angular.element(document.body)
        targetEvent: ev
        fullscreen: $mdMedia('xs')
        clickOutsideToClose: true
      )

    # used for debugging...
    #$scope.raw_scans = [{type:'ply',name:'raw_scan_0.ply',file_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',file_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0.ply',url:'http://irgendwas'}]
    #$scope.meshes = [{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'}]
    #$scope.m_filters = [{file_name:'filter_1.mlx',name:'filter_1'},{file_name:'filter_2.mlx',name:'filter_2'},{file_name:'filter_3.mlx',name:'filter_3'}]

    $scope.getScans = () ->
      scan_promise = $http.get(Configuration.installation.httpurl+'api/v1/scans/'+FSScanService.getScanId())
      scan_promise.then (payload) ->
        $log.debug payload
        $scope.raw_scans = payload.data.raw_scans
        $scope.meshes = payload.data.meshes
        $scope.settings = payload.data.settings

    $scope.getScans()

    $scope.downloadFile = (filename) ->
        window.open(filename)

    $scope.deleteFile = (filename) ->
      $scope.toggleShareDialog()
      promise = $http.delete(Configuration.installation.httpurl+'api/v1/scans/'+FSScanService.getScanId()+'/files/'+filename)
      promise.then (payload) ->
        $log.info payload.data
        $scope.getScans()

        if payload.data.response == "SCAN_DELETED"
          toaster.info('Scan "'+payload.data['scan_id']+'" deleted')
          FSScanService.setScanId(null)
          $scope.setScanLoaded(false)
          $rootScope.$broadcast('clearView')
        else:
          toaster.info('File "'+filename+'" deleted')

    $scope.deleteScan = ()->
      $scope.toggleShareDialog()
      promise = $http.delete(Configuration.installation.httpurl+'api/v1/delete/'+FSScanService.getScanId())
      promise.then (payload) ->
        $log.info payload.data

        toaster.info('Scan '+FSScanService.getScanId()+ ' deleted')
        FSScanService.setScanId(null)
        $rootScope.$broadcast('clearView')

    $scope.loadPointCloud = (filename) ->
        $scope.loadedFile = filename
        $log.inof($scope.loadedFile)
        $scope.toggleShareDialog()
        $scope.scanComplete = false
        toastr.info("Loading file...")
        $scope.loadPLY(filename)

    $scope.loadSTLMesh = (filename) ->
        $scope.loadedFile = filename
        $scope.toggleShareDialog()
        $scope.scanComplete = false
        toastr.info("Loading file...")
        $scope.loadSTL(filename)


    $scope.loadMesh = (mesh) ->
        extension = getFileExtension(mesh)
        if extension == 'stl'
          $scope.loadSTLMesh(mesh)
        if extension == 'ply'
          $scope.loadPLY(mesh)


])