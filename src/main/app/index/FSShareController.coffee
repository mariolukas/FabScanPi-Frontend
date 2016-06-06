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


    $scope.settings = null
    $scope.id = FSScanService.getScanId()
    $scope.selectedTab = 'download'
    $scope.raw_scans = []
    $scope.meshes = []
    # used for debugging...
    #$scope.raw_scans = [{type:'ply',name:'raw_scan_0.ply',file_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',file_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0.ply',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0.ply',url:'http://irgendwas'}]
    #$scope.meshes = [{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'},{type:'ply',name:'raw_scan_0.ply',filter_name:'raw_scan_0',url:'http://irgendwas'}]
    #$scope.m_filters = [{file_name:'filter_1.mlx',name:'filter_1'},{file_name:'filter_2.mlx',name:'filter_2'},{file_name:'filter_3.mlx',name:'filter_3'}]


    $scope.file_formats = ['stl','ply','obj']
    $scope.selectedFormat = $scope.file_formats[0]

    $scope.getScans = () ->
      scan_promise = $http.get(Configuration.installation.httpurl+'api/v1/scans/'+FSScanService.getScanId())
      scan_promise.then (payload) ->
        $log.info payload
        $scope.raw_scans = payload.data.raw_scans
        $scope.meshes = payload.data.meshes
        $scope.settings = payload.data.settings

    $scope.getScans()


    $scope.slickFormatConfig =
      enabled: true
      autoplay: false
      draggable: false
      autoplaySpeed: 3000
      slidesToShow:1
      method: {}
      event:
        afterChange: (event, slick, currentSlide, nextSlide) ->
          $scope.selectedFormat = $(slick.$slides.get(currentSlide)).data('value')

    $scope.slickFilterConfig =
      enabled: true
      autoplay: false
      draggable: false
      autoplaySpeed: 3000
      slidesToShow:1
      method: {}
      event:
        afterChange: (event, slick, currentSlide, nextSlide) ->
          $scope.selectedFilter = $(slick.$slides.get(currentSlide)).data('value')

    $scope.appendFormatListener = ->
      $('.f_format').on 'afterChange', (event, slick, currentSlide, nextSlide) ->
        $scope.selectedFormat = $(slick.$slides.get(currentSlide)).data('value')
      return

    $scope.appendFilterListener = ->
      $('.m_filter').on 'afterChange', (event, slick, currentSlide, nextSlide) ->
        $scope.selectedFilter = $(slick.$slides.get(currentSlide)).data('value')
      return

    $scope.selectTab  = (tab)->
      $scope.selectedTab = tab

    $scope.nextSubSelection= () ->
      $('.filter-container').slick('slickNext')
      return false

    $scope.previewsSubSelection= () ->
      $('.filter-container').slick('slickPrev')
      return false


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

    $scope.loadPointCloud = (pointcloud) ->
        $scope.toggleShareDialog()
        $scope.scanComplete = false
        toastr.info("Loading file...")
        $scope.loadPLY(pointcloud)

    $scope.loadSTLMesh = (filename) ->
        $scope.toggleShareDialog()
        $scope.scanComplete = false
        toastr.info("Loading file...")
        $scope.loadSTL(filename)

    getFileExtension = (filename) ->
        return filename.split('.').pop()

    $scope.loadMesh = (mesh) ->
        #do somethein
        extension = getFileExtension(mesh)
        if extension == 'stl'
          $scope.loadSTLMesh(mesh)
        if extension == 'ply'
          $scope.loadPLY(mesh)

    $scope.runMeshing = () ->
        $scope.toggleShareDialog()
        $log.info $scope.selectedFilter
        $log.info $scope.selectedFormat
        FSScanService.runMeshing(FSScanService.getScanId(), $scope.selectedFilter, $scope.selectedFormat)



])