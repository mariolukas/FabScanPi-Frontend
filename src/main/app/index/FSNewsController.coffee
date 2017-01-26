name = "fabscan.controller.FSNewsController"

angular.module(name, []).controller(name, [
  '$log',
  '$scope',
  '$http',
  'common.services.Configuration',
  ($log, $scope, $http, configuration) ->

    $scope.news = "No news available."
    $http({method: 'GET', url: configuration.newsurl}).
      success((data, status, headers, config) ->
        $scope.news = data
      ).
      error((data, status, headers, config) ->
        $scope.news = "Error retrieving news."
      )
])
