name = 'common.services.Configuration'

angular.module(name, []).factory(name, [
  '$log',
  '$location'
  ($log, $location) ->

    localDebug  =  $location.host() is 'localhost'
    config = null
    devDebug = true
    host = $location.host()

    if localDebug
      config = {
          installation:
            host: host
            websocketurl: 'ws://'+host+':8010/'
            httpurl: 'http://'+host+':8080/'
          newsurl: 'http://'+host+':8000/news/'
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
