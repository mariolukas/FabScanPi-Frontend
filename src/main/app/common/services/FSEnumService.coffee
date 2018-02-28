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
          ON_NET_CONNECT: "ON_NET_CONNECT"
          ON_GET_SETTINGS: "ON_GET_SETTINGS"
          ON_GET_CONFIG: "ON_GET_CONFIG"

    FSEnumService.states =
          IDLE: 'IDLE'
          SCANNING: 'SCANNING'
          SETTINGS: 'SETTINGS'
          CALIBRATING: 'CALIBRATING'
          UPGRADING: 'UPGRADING'

    FSEnumService.commands =
          SCAN: 'SCAN'
          START: 'START'
          STOP: 'STOP'
          CALIBRATE: 'CALIBRATE'
          UPDATE_SETTINGS: 'UPDATE_SETTINGS'
          MESHING: 'MESHING'
          NETCONNECT: "NETCONNECT"
          UPGRADE_SERVER: 'UPGRADE_SERVER'
          REBOOT_SYSTEM: 'REBOOT_SYSTEM'
          SHUTDOWN_SYSTEM: 'SHUTDOWN_SYSTEM'
          RESTART_SERVER: 'RESTART_SERVER'
          HARDWARE_TEST_FUNCTION: 'HARDWARE_TEST_FUNCTION'
          GET_SETTINGS: 'GET_SETTINGS'
          GET_CONFIG: 'GET_CONFIG'
          CONFIG_MODE_ON: 'CONFIG_MODE_ON'


    return FSEnumService

)
