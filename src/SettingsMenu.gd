extends PanelContainer


func Initialize():
	$Main/Tabs/Misc/ToggleAbout/HBox/Button.pressed = GameState.SettAbt
	_onAboutToggled(GameState.SettAbt)
	$Main/Tabs/Misc/ToggleMarket/HBox/Button.pressed = GameState.SettMrkt
	_onMarketToggled(GameState.SettMrkt)
	$Main/Tabs/Misc/ToggleExit/HBox/Button.pressed = GameState.SettExit
	_onExtToggled(GameState.SettExit)
	$Main/Tabs/Misc/ToggleLoad/HBox/Button.pressed = GameState.SettLoad
	_onLoadToggled(GameState.SettLoad)


func _emit(prop, pressed):
	var m = get_node("Main/Tabs/Misc")
	get_parent().get_node("Buttons/"+prop).disabled = not pressed
	
	if GameState.Step == 3:
		if m.get_node("ToggleAbout/HBox/Button").pressed and m.get_node("ToggleLoad/HBox/Button").pressed and m.get_node("ToggleMarket/HBox/Button").pressed and m.get_node("ToggleExit/HBox/Button").pressed:
			GameState.SetStep(4)
			Debugger.CompleteAction()


func _onMarketToggled(button_pressed):
	GameState.SettMrkt = button_pressed
	_emit("Store", button_pressed)

func _onAboutToggled(button_pressed):
	GameState.SettAbt = button_pressed
	_emit("About", button_pressed)

func _onExtToggled(button_pressed):
	GameState.SettExit = button_pressed
	_emit("Exit", button_pressed)

func _onLoadToggled(button_pressed):
	GameState.SettLoad = button_pressed
	_emit("LoadGame", button_pressed)
