name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'

    config = null
    host = $location.host()
    $log.info(host)

    if localDebug
      config = {
          installation:
            host: "fabscanpi.local"
            websocketurl: 'ws://fabscanpi.local/websocket'
            httpurl: 'http://fabscanpi.local:8080/'
            newsurl: 'http://mariolukas.github.io/FabScanPi-Server/news/'
      }
    else
      config = {
        installation:
          host: host
          websocketurl: 'ws://'+host+'/websocket'
          httpurl: 'http://'+host+':8080/'
          newsurl: 'http://mariolukas.github.io/FabScanPi-Server/news/'
      }

    config
])
