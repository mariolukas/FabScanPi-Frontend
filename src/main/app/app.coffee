### ###########################################################################
# Wire modules together
### ###########################################################################

mods = [
  'common.services.envProvider'
  'common.filters.currentStateFilter'
  'common.filters.toLabelFilter'
  'common.filters.toResolutionValue'

  'fabscan.directives.FSWebglDirective'
  'fabscan.directives.FSMJPEGStream'
  'fabscan.directives.FSModalDialog'
  'fabscan.directives.text'

  'fabscan.services.FSMessageHandlerService'
  'fabscan.services.FSEnumService'
  'fabscan.services.FSWebsocketConnectionFactory'
  'fabscan.services.FSScanService'
  'fabscan.services.FSi18nService'
  'common.filters.scanDataAvailableFilter'
  'fabscan.directives.onSizeChanged'

  'common.services.Configuration'
  'common.services.toastrWrapperSvc'

  'fabscan.controller.FSPreviewController'
  'fabscan.controller.FSAppController'
  'fabscan.controller.FSNewsController'
  'fabscan.controller.FSSettingsController'
  'fabscan.controller.FSScanController'
  'fabscan.controller.FSLoadingController'
  'fabscan.controller.FSShareController'

  'ngSanitize'
  'ngTouch'
  'ngCookies'

  '720kb.tooltips'
  'ngProgress'

  'vr.directives.slider'
  'slickCarousel'
   #'ng.jsoneditor'
]

### ###########################################################################
# Declare routes
### ###########################################################################

#routesConfigFn = ($routeProvider)->


#	$routeProvider.otherwise({redirectTo: '/'})

### ###########################################################################
# Create and bootstrap app module
### ###########################################################################

m = angular.module('fabscan', mods)

#m.config ['$routeProvider', routesConfigFn]


m.config (['common.services.envProvider', (envProvider)->
	# Allows the environment provider to run whatever config block it wants.
	if envProvider.appConfig?
		envProvider.appConfig()
])


m.run (['common.services.env', (env)->
	# Allows the environment service to run whatever app run block it wants.
	if env.appRun?
		env.appRun()
])


m.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.useXDomain = true;
 # delete $httpProvider.defaults.headers.common['X-Requested-With'];
])


angular.element(document).ready ()->
	angular.bootstrap(document,['fabscan'])
