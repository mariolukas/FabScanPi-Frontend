name = 'fabscan.services.FSEnumService'

angular.module(name, []).factory(name, () ->

    FSEnumService = {}

    FSEnumService.events =
          ON_NEW_PROGRESS: 'ON_NEW_PROGRESS'
          ON_STATE_CHANGED: 'ON_STATE_CHANGED'
          COMMAND: 'COMMAND'
          ON_CLIENT_INIT: 'ON_CLIENT_INIT'
          ON_INFO_MESSAGE: 'ON_INFO_MESSAGE'
          SCAN_LOADED: "SCAN_LOADED"



    FSEnumService.states =
          IDLE: 'IDLE'
          SCANNING: 'SCANNING'
          SETTINGS: 'SETTINGS'

    FSEnumService.commands =
          SCAN: 'SCAN'
          START: 'START'
          STOP: 'STOP'
          UPDATE_SETTINGS: 'UPDATE_SETTINGS'

    return FSEnumService

)