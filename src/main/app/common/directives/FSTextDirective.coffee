name = 'fabscan.directives.text'
angular.module(name,[]).directive("text", [
	'fabscan.services.FSi18nService'
	(i18n)->
		restrict: 'A'
		link: (scope, element, attrs) ->
			renderText = ->
				element[0].textContent = i18n.formatText(attrs.text)

			scope.$watch( ->
				attrs.text
			, ->
				renderText()
			)

			return
])
