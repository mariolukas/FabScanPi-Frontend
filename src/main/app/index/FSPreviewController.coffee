name = "fabscan.controller.FSPreviewController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$rootScope',
  '$http',
  'ngProgress',
  'common.services.Configuration'
  'fabscan.services.FSEnumService'
  'fabscan.services.FSScanService'
  ($log, $scope,$rootScope,$http, ngProgress, Configuration, FSEnum, FSScanService ) ->

    $scope.canvasWidth = 400
    $scope.canvasHeight = 500
    $scope.dofillcontainer = true
    $scope.scale = 1
    $scope.materialType = 'lambert'
    $scope.addPoints = null
    $scope.resolution = null
    $scope.progress = null
    $scope.newPoints = null

    $scope.loadPLY = null
    $scope.loadSTL = null
    $scope.renderer = null

    $scope.showStream = false
    $scope.startTime = null
    $scope.sampledRemainingTime = 0
    $scope.remainingTimeString = "0 minutes 0 seconds"
    #$scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'

    if FSScanService.getScannerState() is FSEnum.states.CALIBRATING
        $scope.showStream = true

    $scope.$on(FSEnum.events.ON_STATE_CHANGED, (event, data)->
        if data['state'] == FSEnum.states.IDLE
          $scope.showStream = false
        #if data['state'] == FSEnum.states.CALIBRATING
        #  $scope.showStream = true
    )

    $rootScope.$on('clearView', ()->
        $scope.clearView()
    )

    $scope.$on(FSEnum.events.ON_INFO_MESSAGE, (event, data) ->
        if data['message'] == 'SCANNING_TEXTURE'
          $scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'
          $scope.showStream = true
          $scope.$apply()

        if data['message'] == 'START_CALIBRATION'
          $scope.streamUrl = Configuration.installation.httpurl+'stream/texture.mjpeg'
          $scope.showStream = true

        if data['message'] == 'STOP_CALIBRATION'
          $scope.showStream = false
          $scope.streamUrl = ""

        if data['message'] == 'SCANNING_OBJECT'
          $scope.showStream = false
          $scope.streamUrl = ""
          $scope.$apply()

        if data['message'] == 'SCAN_COMPLETE'
          FSScanService.setScanId(data['scan_id'])
          $scope.setScanIsComplete(true)
          $scope.showStream = false
          $scope.remainingTime = []
          $scope.startTime = null
          $scope.sampledRemainingTime = 0
          $scope.progress = 0
          #if ngProgress.status() == 100
          #  ngProgress.complete()

        if data['message'] == 'SCAN_CANCELED' || data['message'] == 'SCAN_STOPED'
          $scope.remainingTime = []
          $scope.showStream = false
          $scope.startTime = null
          $scope.progress = 0
          $scope.sampledRemainingTime = 0
    )


    $scope.$on(FSEnum.events.ON_NEW_PROGRESS,  (event, data) ->

      if  FSScanService.state != FSEnum.states.IDLE
            $scope.resolution = data['resolution']
            $scope.progress = data['progress']

            percentage = $scope.progress/$scope.resolution*100

            $scope.startTime = FSScanService.getStartTime()
            if $scope.progress <= 1
              $scope.sampledRemainingTime = 0
              _time_values = []
              #ngProgress.start()

            else

              timeTaken = (Date.now() - $scope.startTime)
              $scope.remainingTime.push(parseFloat(Math.floor(((timeTaken/ $scope.progress)* ($scope.resolution - $scope.progress))/1000)))

              if $scope.remainingTime.length > 20
                _time_values = $scope.remainingTime.slice(Math.max($scope.remainingTime.length-8,1))
              else
                _time_values = $scope.remainingTime

              $scope.sampledRemainingTime = parseFloat(Math.floor(median(_time_values)))

              if $scope.sampledRemainingTime > 60
                  $scope.remainingTimeString =  parseInt($scope.sampledRemainingTime/60)+" minutes"
              else
                  $scope.remainingTimeString = ($scope.sampledRemainingTime)+" seconds"

              $log.debug percentage.toFixed(2) + "% complete"
              ngProgress.set(percentage)

            if percentage >= 98
              $scope.sampledRemainingTime = 0
              _time_values = []

            $scope.addPoints(data['points'],data['progress'],data['resolution'])


    )


    $scope.progressHandler = (item) ->

      if $scope.progress == 0
        ngProgress.start()
        $scope.progress = item.total

      percentage = item.loaded/item.total*100
      ngProgress.set(percentage)

      #toastr.info("Loading Scan "+item.loaded)
      if (item.loaded == item.total)

        $scope.progress = 0
        ngProgress.complete()
        percentage = 0
        $scope.setScanIsLoading(false)
        $scope.setScanLoaded(true)

        $scope.$apply()

    median = (values) ->
      values.sort (a, b) ->
        a - b
      half = Math.floor(values.length / 2)
      if values.length % 2
        values[half]
      else
        (values[half - 1] + values[half]) / 2.0


    $scope.setRenderTypeCallback = (callback) ->
      $scope.renderObjectAsType = callback

    $scope.loadPLYHandlerCallback = (callback) ->
      $scope.loadPLY = callback

    $scope.loadSTLHandlerCallback = (callback) ->
      $scope.loadSTL = callback

    $scope.setPointHandlerCallback = (callback) ->
      $scope.addPoints = callback

    $scope.setClearViewHandlerCallback = (callback) ->
      $scope.clearView = callback

    $scope.getRendererCallback = (renderer) ->
      $scope.renderer = renderer

])