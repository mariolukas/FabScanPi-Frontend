name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'
    config = null
    devDebug = true

    if localDebug
      #host = $location.host()
      host = "fabscanpi.local"
      config = {
          installation:
            host: host
            websocketurl: 'ws://'+host+':8010/'
            httpurl: 'http://'+host+':8080/'
      }

    else
      host = $location.host()
      config = {
        installation:
          host: host
          websocketurl: 'ws://'+$location.host()+':8010/'
          httpurl: 'http://'+$location.host()+':8080/'

      }

    config
])