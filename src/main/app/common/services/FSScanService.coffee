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
    service.startTime = null
    service.loadedFile = undefined

    service.scanComplete = false
    service.scanProgress = 0

    service.setScanProgress = (value) ->
        service.scanProgress = value

    service.getScanProgress = ->
        return service.scanProgress

    service.setScanIsComplete = (value) ->
        service.scanComplete = value

    service.scanIsComplete = ->
        return service.scanComplete

    service.initStartTime = ->
      service.startTime = Date.now()

    service.setStartTime = (time) ->
      service.startTime = time

    service.getStartTime = ->
      service.startTime

    service.getScanId = () ->
      service.scanId

    service.setScanId = (id) ->
      service.scanId = id

    service.startScan = (options) ->

      service.state = FSEnumService.states.SCANNING
      service.setScanId(null)
      service.initStartTime()
      # FIXME: ( or find better solution )
      # needed to be done here, cause raspberry has not a real time clock,
      # when no internet connection is availabale on the fabscan the time
      # will be set (default) to 1970, this leads to a wrong calculation...

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.START
          startTime: service.getStartTime()


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
      service.getSettings()

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.SCAN
          #settings: settings

      FSMessageHandlerService.sendData(message)

    service.getSettings = () ->

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.GET_SETTINGS

      FSMessageHandlerService.sendData(message)

    service.getConfig = () ->

      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.GET_CONFIG

      FSMessageHandlerService.sendData(message)

    service.configModeOn = () ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.CONFIG_MODE_ON,
      FSMessageHandlerService.sendData(message)

    service.upgradeServer = () ->
      $log.debug("Upgrade Server called.")
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.UPGRADE_SERVER

      FSMessageHandlerService.sendData(message)

    service.restartServer = () ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.RESTART_SERVER

      FSMessageHandlerService.sendData(message)

    service.rebootSystem = () ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.REBOOT_SYSTEM

      FSMessageHandlerService.sendData(message)

    service.shutdownSystem = () ->
      message = {}
      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.SHUTDOWN_SYSTEM

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

    service.startCalibration = () ->
      message = {}
      service.initStartTime()

      message =
        event: FSEnumService.events.COMMAND
        data:
          command: FSEnumService.commands.CALIBRATE
          startTime: service.getStartTime()

      FSMessageHandlerService.sendData(message)
      $rootScope.$broadcast(FSEnumService.commands.CALIBRATE)

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
      $rootScope.$broadcast('stateChanged', service.state)

    service.setLoadedFile = (filename) ->
      service.loadedFile = filename

    service.getLoadedFile = ()->
      return service.loadedFile

    service

])
