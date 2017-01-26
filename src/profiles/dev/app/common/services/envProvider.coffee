###
DEV
###
providerName = 'common.services.env' # angular adds the 'Provider' suffix for us.
modName = "#{providerName}Provider"

class Environment

	env: 'DEV'

class EnvironmentProvider

	$get: ()->
		new Environment()

mod = angular.module(modName, [])
mod.provider(providerName, new EnvironmentProvider())
