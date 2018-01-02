name = "fabscan.controller.FSNewsController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$http',
  '$timeout',
  '$cookies',
  '$q',
  'common.services.Configuration',
  ($log, $scope, $http, $timeout, $cookies, $q, configuration) ->


    hashCode = (str) ->
      hash = 0
      if str.length == 0
        return hash
      i = 0
      while i < str.length
        char = str.charCodeAt(i)
        hash = (hash << 5) - hash + char
        hash = hash & hash
        # Convert to 32bit integer
        i++
      hash

    timeoutPromise = $timeout((->
      #aborts the request when timed out
      deferred.resolve()
      console.log 'News request timeout...'
      $scope.displayNews(false)
      return
    ), 250)


    deferred = $q.defer();

    $scope.news = "No news available."

    $http(
      method: 'GET',
      url: configuration.installation.newsurl,
      timeout: deferred.promise
    ).then ((response) ->
        newsHASH = hashCode(response.data)
        if newsHASH == $cookies.newsHASH
          $log.debug("Nothing new here")
        else
          $log.debug("Some news are available")

        #$log.info("News Hash "+hashCode(data))
        $scope.news = response.data
        $timeout.cancel(timeoutPromise);
        return
    ), (response) ->
        $scope.news = "Error retrieving news."
        return

])
