name = 'fabscan.services.FSi18nService'

angular.module(name, []).factory(name, [
  '$log',
  '$rootScope'
  'fabscan.services.FSEnumService',
  ($log,$rootScope, FSEnumService) ->

    service = {}

    service.translateKey = (key, value) ->
        return window.i18n[key][value]()

    service

])