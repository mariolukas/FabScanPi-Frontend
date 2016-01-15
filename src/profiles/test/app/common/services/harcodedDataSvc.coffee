name = 'ambiHome.services.harcodedDataSvc'

class HardCodedData

	project =
		components:[
			name: "Tisch"
			type: "Light"
			id: "kitchen_1_light_1"
			actions:[
				type:"Switching"
				id: "kitchen_1_light_1_switching"
				,
				type: "Toggle"
				id: "kitchen_1_light_1_toggle"
			]
			locationRefs:[
				"kitchen_1"
			]
		,
			name: "Vorne"
			type: "Blind"
			id: "hallway_1_light_1"
			actions:[
				type:"Switching"
				id: "hallway_1_blind_1_switching"
				,
				type: "Toggle"
			]
			locationRefs:[
				"hallway_1"
			]
		,
			name: "Tür"
			type: "ControlPanel"
			id: "hallway_1_switch_1"
			controlElements:[
				type: "SinglePushButton"
				id: "SinglePushButton_1"
				actionTriggers:
					trigger:
						type: "ActionTrigger"
						component: "kitchen_1_light_1"
						action: "Switching"
						parameter:[
							type: "SwitchValue"
							value: "off"
						]
			,
				type: "DoublePushButton"
				id: "DoublePushButton_1"
				actionTriggers:
					leftTrigger:
						type: "ActionTrigger"
						component: "kitchen_1_light_1"
						action: "Switching"
						parameter:[
							type: "SwitchValue"
							value: "off"
						]
					rightTrigger:
						type: "ActionTrigger"
						component: "kitchen_1_light_1"
						action: "Switching"
						parameter:[
							type: "SwitchValue"
							value: "on"
						]
			]
			locationRefs:[
				"hallway_1"
			]
		]
		locations: [
			id: "kitchen_1",
			name: "Küche"
			type: "kitchen"
		,
			id: "hallway_1"
			name: "Flur"
			type: "hallway"
		]
		componentTypes:[
			"Light"
		]
		ids:
			kitchen: 1
			hallway: 1
			SinglePushButton: 1
			DoublePushButton: 1

	###
	Builds an 'ok' response for the 'respond' method
	###
	buildOkResp: (data) ->
		return [200, data, {}]

	addHardcodedData: ($httpBackend) ->

		$httpBackend.whenGET(/html$/).passThrough() # all html can pass

		$httpBackend.whenGET('/projects').respond @project

		projectRE = /\/project\/(\d+)/
		$httpBackend.whenGET(projectRE).respond (method, url, data)=>
			id = parseInt(projectRE.exec(url)[1])
			@buildOkResp(project)
			#@buildOkResp (person for person in @people when person.id == id)[0]


angular.module(name, []).factory(name, () ->
	new HardCodedData()
)