name = 'fabscan.directives.onSizeChanged'
angular.module(name,[]).directive 'onSizeChanged', [
  '$window'
  ($window) ->
    {
      restrict: 'A'
      scope: onSizeChanged: '&'
      link: (scope, $element, attr) ->
        element = $element[0]

        cacheElementSize = (scope, element) ->
          scope.cachedElementWidth = element.offsetWidth
          scope.cachedElementHeight = element.offsetHeight
          return

        onWindowResize = ->
          isSizeChanged = scope.cachedElementWidth != element.offsetWidth or scope.cachedElementHeight != element.offsetHeight
          if isSizeChanged
            expression = scope.onSizeChanged()
            expression()
          return

        cacheElementSize scope, element
        $window.addEventListener 'resize', onWindowResize
        return

    }
]