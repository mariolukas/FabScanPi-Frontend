name = 'fabscan.directives.slick'
angular.module(name,[]).directive("slickSlider", [
  '$log'
  '$timeout'
  ($log,$timeout)->
    restrict: 'A'
    link: (scope, element, attrs) ->
      $timeout ->
        $(element).slick scope.$eval(attrs.slickSlider)
        return
      return

])
