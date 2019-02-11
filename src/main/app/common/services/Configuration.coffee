name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'

    config = null
    host = $location.host()
    http = 'http'
    ws = 'ws'

    console.log($location.protocol())
    if $location.protocol() is 'https'
      http = 'https'
      ws = 'wss'

    if localDebug
      config = {
          installation:
            host: "fabscanpi.local"
            websocketurl: ws+'://fabscanpi.local/websocket'
            httpurl: http+'://fabscanpi.local/'
            newsurl: http+'://fabscanpi-server.readthedocs.io/en/latest/news/'
            apiurl: http + '://fabscanpi.local/'
      }
    else
      config = {
        installation:
          host: host
          websocketurl: ws + '://' + host + '/websocket'
          httpurl: http + '://' + host + ':8080/'
          newsurl: http + '://fabscanpi-server.readthedocs.io/en/latest/news/'
          apiurl: http + '://' + host + '/'
      }

    config
])
