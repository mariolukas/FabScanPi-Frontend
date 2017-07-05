name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'

    config = null
    host = $location.host()
    $log.info(host)
    #localDebug = true

    if localDebug
      config = {
          installation:
            host: "192.168.178.31"
            websocketurl: 'ws://fabscanpi.local:8010/'
            httpurl: 'http://192.168.1.121:8080/'
            newsurl: 'http://mariolukas.github.io/FabScanPi-Server/news/'
      }
    else
      config = {
        installation:
          host: host
          websocketurl: 'ws://'+host+':8010/'
          httpurl: 'http://'+host+':8080/'
          newsurl: 'http://mariolukas.github.io/FabScanPi-Server/news/'
      }

    config
])
