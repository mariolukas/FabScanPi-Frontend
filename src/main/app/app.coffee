### ###########################################################################
# Wire modules together
### ###########################################################################

mods = [
  'common.services.envProvider'
  'common.filters.currentStateFilter'
	'common.filters.toLabelFilter'
	'common.filters.toResolutionValue'
  'common.filters.wifiIconClassFilter'
  'common.filters.networkModeLabelFilter'
  'common.filters.itemToolBarStateFilter'


  'fabscan.directives.FSWebglDirective'
  'fabscan.directives.FSMJPEGStream'
  'fabscan.directives.FSModalDialog'
  'fabscan.directives.text'

  'fabscan.services.FSMessageHandlerService'
  'fabscan.services.FSEnumService'
  'fabscan.services.FSWebsocketConnectionFactory'
  'fabscan.services.FSScanService'
  'fabscan.services.FSi18nService'
  'fabscan.services.FSWebGlService'
	'common.filters.scanDataAvailableFilter'

  'common.services.Configuration'
  'common.services.FSToasterService'

  'fabscan.controller.FSCanvasController'
  'fabscan.controller.FSAppController'
  'fabscan.controller.FSNewsController'
  'fabscan.controller.FSSettingsController'

	'fabscan.controller.FSScanGalleryController'
	'fabscan.controller.FSToolsController'
  'fabscan.controller.FSConfigController'
  'fabscan.controller.FSToolbarController'
  'fabscan.controller.FSSplashController'

	'ngSanitize'
  'ngCookies'

#  'vr.directives.slider'
  'ngMaterial'
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


m.config (['common.services.envProvider', ( envProvider )->
	# Allows the environment provider to run whatever config block it wants.
	if envProvider.appConfig?
		envProvider.appConfig()

])


m.run (['common.services.env', (env)->
	# Allows the environment service to run whatever app run block it wants.
	if env.appRun?
		env.appRun()
])


m.config(['$httpProvider','$mdThemingProvider', ($httpProvider, $mdThemingProvider) ->
  $httpProvider.defaults.useXDomain = true;
  $mdThemingProvider.theme('default')
    .primaryPalette('blue-grey')
    .accentPalette('red');
 # delete $httpProvider.defaults.headers.common['X-Requested-With'];
])


angular.element(document).ready ()->
	angular.bootstrap(document,['fabscan'])
