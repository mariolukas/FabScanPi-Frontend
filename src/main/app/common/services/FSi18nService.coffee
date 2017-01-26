name = 'fabscan.services.FSi18nService'

angular.module(name, []).factory(name, [
	'$window',
	($window) ->

		service = {}

		service.formatText = (key, values = { }) ->
			[catalogId, textId] = key.split(".")
			if catalogId && textId
				if catalogId of $window.i18n
					catalog = $window.i18n[catalogId]
					if textId of catalog
						return catalog[textId](values)
			return key
		return service
])
