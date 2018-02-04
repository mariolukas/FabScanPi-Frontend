name = 'fabscan.services.FSMessageHandlerService'


angular.module(name, []).factory(name, [
    '$log',
    '$timeout',
    '$rootScope',
    '$http',
    'fabscan.services.FSWebsocketConnectionFactory',
    'common.services.Configuration',
    ($log, $timeout, $rootScope, $http, FSWebsocketConnectionFactory, Configuration) ->

      socket = null

      FSMessageHandlerService = {}
      FSMessageHandlerService.connectToScanner = (scope)->

        scope.isConnected = false

        socket = FSWebsocketConnectionFactory.createWebsocketConnection(Configuration.installation.websocketurl)

        socket.isConnected = ()->
          return scope.isConnected

        socket.onopen = (event) ->
            scope.isConnected = true
            $rootScope.$broadcast("CONNECTION_STATE_CHANGED", scope.isConnected)
            console.log 'Websocket connected to '+socket.url


        socket.onerror = (event) ->

            console.error event

        socket.onclose = (event) ->
            scope.isConnected = false
            socket = null
            $rootScope.$broadcast("CONNECTION_STATE_CHANGED", scope.isConnected)
            $timeout(() ->
              FSMessageHandlerService.connectToScanner(scope)
            ,2000)
            console.log "Connection closed"

        socket.onmessage = (event) ->
            message = jQuery.parseJSON( event.data )
            #$log.info(message['data'])
            $rootScope.$broadcast(message['type'], message['data'])

      FSMessageHandlerService.sendData = (message) ->
        socket.send(JSON.stringify(message))


      return FSMessageHandlerService
])