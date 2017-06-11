name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'

    config = null
    devDebug = true
    host = $location.host()

    if devDebug
      config = {
          installation:
            host: 'fabscanpi.local'
            websocketurl: 'ws://fabscanpi.local:8010/'
            httpurl: 'http://fabscanpi.local:8080/'
            newsurl: 'http://mariolukas.github.io/FabScanPi-Server/news/'
      }

    else
      config = {
        installation:
          host: host
          websocketurl: 'ws://'+host+':8010/'
          httpurl: 'http://'+host+':8080/'

      }

    config
])
