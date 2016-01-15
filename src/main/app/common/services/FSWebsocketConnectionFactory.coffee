
name = 'fabscan.services.FSWebsocketConnectionFactory'

angular.module(name, []).factory(name, () ->
  service = {}
  service.createWebsocketConnection = (url) ->
    new WebSocket(url)
  service
)