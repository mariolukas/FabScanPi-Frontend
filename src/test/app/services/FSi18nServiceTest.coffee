describe "fabscan.services.FSi18nService", ->
	service = null

	beforeEach(module("fabscan.services.FSi18nService"))

	beforeEach(
		inject([
			"fabscan.services.FSi18nService",
			"$window",
			(i18n, $window) ->
				$window.i18n = {
					'catalog': {
						'KEY_WITHOUT_PARAMS': () ->
							return "Message without param"
					}
				}
				service = i18n
			])
	)

	it "should exist", ->
		expect(service).not.toBeNull()

	it "should contain formatText function", ->
		expect(service.formatText).toBeDefined()

	describe "formatText", ->
		it "should return the text without parameters", ->
			result = service.formatText("catalog.KEY_WITHOUT_PARAMS")
			expect(result).toEqual("Message without param")

		it "should return the text id if catalog does not exist", ->
			result = service.formatText("otherCatalog.ANY_KEY")
			expect(result).toEqual("otherCatalog.ANY_KEY")

		it "should return the text id if text does not exist in catalog", ->
			result = service.formatText("catalog.NOT_EXISTING_KEY")
			expect(result).toEqual("catalog.NOT_EXISTING_KEY")
