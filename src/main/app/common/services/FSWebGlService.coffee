name = 'fabscan.services.FSWebGlService'

angular.module(name, []).factory(name, [
  '$log',
  ($log) ->

    service = {}

    service.renderObjectAsType = null
    service.loadPLY = null
    service.loadSTL = null
    service.addPoints = null
    service._clearView = null
    service.renderer = null

    service.scanLoaded = false
    service.scanLoading = false
    service.loadedFile = null

    service.loadPLYFile = (file) ->
      service.loadedFile = file
      service.loadPLY(file)

    service.clearView = () ->
      service.scanLoaded = false
      service.scanLoading = false
      service._clearView()

    service.setRenderObjectAsCallback = (callback) ->
      service.renderObjectAsType = callback

    service.setRendererCallback = (callback) ->
      service.renderer = callback

    service.setPLYLoaderCallback = (callback) ->
      service.loadPLY = callback

    service.setSTLLoaderCallback = (callback) ->
      service.loadSTL = callback

    service.setAddPointsCallback = (callback) ->
      service.addPoints = callback

    service.setClearViewCallback = (callback) ->
      service._clearView = callback

    service.setScanLoaded = (value) ->
      service.scanLoaded = value

    service.scanIsLoaded = ->
      return service.scanLoaded

    service.setScanIsLoading = (value) ->
      service.scanLoading = value

    service.scanIsLoading = ->
      return service.scanLoading

    service

])