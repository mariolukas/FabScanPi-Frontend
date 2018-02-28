name = 'fabscan.services.FSDeviceService'

angular.module(name, []).factory(name, [
  '$log'
  ($log) ->
    service = {}
    service.softwareVersion = '0.0.0'
    service.firmwareVersion = 'latest'

    service.getSoftwareVersion = ->
        return service.softwareVersion

    service.setSoftwareVersion = (version) ->
        service.softwareVersion = version

    service.getFirmwareVersion = ->
        return service.firmwareVersion

    service.setFirmwareVersion = (version) ->
        service.firmwareVersion = version

    return service

])