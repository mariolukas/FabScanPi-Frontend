name = 'fabscan.services.FSScanService'

angular.module(name, []).factory(name, [
  '$log',
  '$rootScope'
  'fabscan.services.FSEnumService',
  'fabscan.services.FSMessageHandlerService'
  ($log,$rootScope, FSEnumService, FSMessageHandlerService) ->
    service = {}

    service.state = FSEnumService.states.IDLE
    service.scanId = null

    service.getScanId = () ->
      service.scanId

    service.setScanId = (id) ->
      service.scanId = id

    service.startScan = (options) ->

      service.state = FSEnumService.states.SCANNING
      service.setScanId(null)

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.START


      FSMessageHandlerService.sendData(message)
      $rootScope.$broadcast(FSEnumService.commands.START)

    service.updateSettings = (settings) ->

      message = {}
      message =
      event: FSEnumService.events.COMMAND
      data:
        command: FSEnumService.commands.UPDATE_SETTINGS
        settings: settings

      FSMessageHandlerService.sendData(message)

    service.startSettings = (settings) ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.SCAN
          #settings: settings

      FSMessageHandlerService.sendData(message)

    service.stopScan = () ->
      service.setScanId(null)
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.STOP

      FSMessageHandlerService.sendData(message)
      $rootScope.$broadcast(FSEnumService.commands.STOP)

    service.runMeshing = (scan_id, filter, format) ->

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.MESHING
          scan_id: scan_id
          format: format
          filter: filter

      FSMessageHandlerService.sendData(message)


    service.exitScan = () ->

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.STOP

      FSMessageHandlerService.sendData(message)

    service.getScannerState = ()->
      service.state


    service.setScannerState = (state) ->
      service.state = state

    service.getSettings = () ->
       message = {}
       message =
        event: FSEnumService.events.COMMAND
        #data:
          #command: FSEnumService.commands.GET_SETTINGS


    service

])