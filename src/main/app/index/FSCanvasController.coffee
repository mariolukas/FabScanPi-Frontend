name = "fabscan.controller.FSCanvasController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  '$document',
  'common.services.Configuration',
  'fabscan.services.FSEnumService',
  'fabscan.services.FSScanService',
  'fabscan.services.FSWebGlService',
  ($log, $scope, $rootScope, $http, $document, Configuration, FSEnum, FSScanService, FSWebGlService ) ->

    $scope.canvasWidth = 400
    $scope.canvasHeight = 500
    $scope.dofillcontainer = true
    $scope.scale = 1
    $scope.materialType = 'lambert'
    $scope.addPoints = null
    $scope.resolution = null
    $scope.progress = null
    $scope.newPoints = null
    previous_percentage = 0

    $scope.loadPLY = null
    $scope.loadSTL = null
    $scope.renderer = null

    $scope.showStream = false
    $scope.startTime = null
    $scope.sampledRemainingTime = 0
    $scope.remainingTimeString = "0 minutes 0 seconds"

    $scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'

    stopStream = () ->
      $log.info("Called stop stream")
      $scope.streamUrl = ""
      $scope.showStream = false
      $scope.$apply()

    startStream = () ->
      $scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'
      $scope.showStream = true
      $scope.$apply()

    resetSate = () ->
      $scope.remainingTime = []
      $scope.showStream = false
      $scope.startTime = null
      $scope.progress = 0
      FSScanService.setScanProgress(0)
      $scope.sampledRemainingTime = 0
      $scope.$apply()

    if FSScanService.getScannerState() is FSEnum.states.CALIBRATING
        $scope.showStream = true

    $scope.$on(FSEnum.events.ON_STATE_CHANGED, (event, data)->
        console.log("State Changed... ")
        if data['state'] == FSEnum.states.IDLE
          stopStream()
          resetSate()
    )

    $rootScope.$on('clearView', ()->
        $scope.clearView()
    )

    $scope.start_stream_conditions = ['SCANNING_TEXTURE', 'START_CALIBRATION']
    $scope.stop_stream_conditions = ['STOPPED_CALIBRATION', 'SCANNING_OBJECT']
    $scope.reset_conditions = ['SCAN_CANCELED', 'SCAN_STOPED']


    $scope.$on(FSEnum.events.ON_INFO_MESSAGE, (event, data) ->
        if data['message'] in $scope.start_stream_conditions
          startStream()

        if data['message'] in $scope.stop_stream_conditions
          stopStream()
          resetSate()

        if data['message'] in $scope.reset_conditions
          resetSate()

        if data['message'] == 'SCAN_COMPLETE'
          FSScanService.setScanId(data['scan_id'])
          $scope.setScanIsComplete(true)
          resetSate()
    )


    $scope.$on(FSEnum.events.ON_NEW_PROGRESS,  (event, data) ->

      if  FSScanService.state != FSEnum.states.IDLE
            $scope.resolution = data['resolution']
            $scope.progress = data['progress']
            $scope.timestamp = data['timestamp']

            percentage = $scope.progress/$scope.resolution*100

            $scope.startTime = data['starttime']
            if $scope.progress <= 1
              $scope.sampledRemainingTime = 0
              _time_values = []

            else

              timeTaken = ($scope.timestamp  - $scope.startTime)
              $scope.remainingTime.push(parseFloat(Math.floor(((timeTaken/ $scope.progress)* ($scope.resolution - $scope.progress))/1000)))

              if $scope.remainingTime.length > 20
                _time_values = $scope.remainingTime.slice(Math.max($scope.remainingTime.length-8,1))
              else
                _time_values = $scope.remainingTime

              $scope.sampledRemainingTime = parseFloat(Math.floor(median(_time_values)))

              if $scope.sampledRemainingTime >= 60
                  $scope.remainingTimeString =  parseInt($scope.sampledRemainingTime/60)+" minutes"
              else
                  $scope.remainingTimeString = ($scope.sampledRemainingTime)+" seconds"

              $log.debug percentage.toFixed(2) + "% complete"

              FSScanService.setScanProgress(percentage)
              $scope.$applyAsync()

            if percentage >= 98
              FSScanService.setScanProgress(0)
              $scope.sampledRemainingTime = 0
              _time_values = []

            $scope.addPoints(data['points'],data['progress'],data['resolution'])
    )


    $scope.progressHandler = (item) ->


      if $scope.progress == 0
        #ngProgress.start()

        $scope.progress = item.total
        previous_percentage = 0
        FSScanService.setScanProgress(0)

      if $scope.progress >= 98
        $scope.progress = 0
        FSScanService.setScanProgress(0)

      percentage = item.loaded/item.total*100

      FSScanService.setScanProgress(percentage)


      if (item.loaded == item.total)

        $scope.progress = 0
        $scope.showProgressBar = false
        FSScanService.setScanProgress(0)
        percentage = 0
        previous_percentage = 0

        FSWebGlService.setScanIsLoading(false)
        FSWebGlService.setScanLoaded(true)


      $scope.$applyAsync()

      previous_percentage = parseInt(percentage)


    median = (values) ->
      values.sort (a, b) ->
        a - b
      half = Math.floor(values.length / 2)
      if values.length % 2
        values[half]
      else
        (values[half - 1] + values[half]) / 2.0


    $scope.setRenderTypeCallback = (callback) ->
      FSWebGlService.setRenderObjectAsCallback(callback)

    $scope.loadPLYHandlerCallback = (callback) ->
      FSWebGlService.setPLYLoaderCallback(callback)

    $scope.loadSTLHandlerCallback = (callback) ->
      FSWebGlService.setSTLLoaderCallback(callback)

    $scope.setPointHandlerCallback = (callback) ->
      FSWebGlService.setAddPointsCallback(callback)

    $scope.setClearViewHandlerCallback = (callback) ->
      FSWebGlService.setClearViewCallback(callback)

    $scope.getRendererCallback = (renderer) ->
      FSWebGlService.setRendererCallback(renderer)

])