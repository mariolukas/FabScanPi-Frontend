describe "fabscan.directives.text", ->
	service = null
	$compile = null
	$rootScope = null
	i18nMock = {
		formatText: ->
			return "My mock text"
	}

	beforeEach(module(($provide) ->
			$provide.service('fabscan.services.FSi18nService', -> i18nMock)
			null
		)
	)
	beforeEach(module("fabscan.directives.text"))
	beforeEach(inject((_$compile_, _$rootScope_) ->
				$compile = _$compile_
				$rootScope = _$rootScope_
		)
	)

	it "should replace textContent based on static attribute", ->
		element = $compile('<div text="test.MY_TEXT_ID"></div>')($rootScope)
		$rootScope.$digest()
		expect(element[0].textContent).toEqual("My mock text");

	it "should replace textContent based on dynamic attribute", ->
		spyOn(i18nMock, 'formatText').andReturn("My first text");
		$rootScope.myTextId = "catalog.FIRST_TEXT_ID"
		element = $compile('<div text="{{ myTextId }}"></div>')($rootScope)
		$rootScope.$apply()
		expect(i18nMock.formatText).toHaveBeenCalledWith("catalog.FIRST_TEXT_ID")
		expect(element[0].textContent).toEqual("My first text");

		i18nMock.formatText = ->
		spyOn(i18nMock, 'formatText').andReturn("My new text");
		$rootScope.myTextId = "catalog.NEW_TEXT_ID"
		$rootScope.$apply()
		expect(i18nMock.formatText).toHaveBeenCalledWith("catalog.NEW_TEXT_ID")
		expect(element[0].textContent).toEqual("My new text");
