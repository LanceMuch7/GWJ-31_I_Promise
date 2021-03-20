extends Control


var offset = Vector2(1000, -900)
var redux = 150


func _ready():
	if GameState.ShowSave:
		EnableSaveFile()
	if GameState.Step == 0:
		$Bg.rect_position = offset
		$Bg.rect_rotation = _getAngle()
	else:
		$Bg/VBox/Divide/Files/Main/Button.visible = GameState.ShowSave
		$Bg/VBox/Start.disabled = false
		$Bg/VBox/Divide/Buttons/Settings.disabled = not GameState.Settings
		$Bg/VBox/Divide/Buttons/Exit.set_button_mask(BUTTON_MASK_LEFT)
		if GameState.Step > 4:
			$Bg/VBox/Divide/Buttons/NewGame.disabled = false
	if GameState.PlayFixed:
		$Bg/VBox/Divide/Buttons/NewGame.icon = $Oregano.texture

func _unhandled_key_input(event):
	if GameState.Step < 2:
		if not event is InputEventMouseMotion and event.is_pressed():
			offset.x = clamp(offset.x - redux, 0, offset.x)
			offset.y = clamp(offset.y + redux, 0, offset.y)
			if offset.distance_to(Vector2.ZERO) < 10:
				offset = Vector2.ZERO
				$Bg.rect_position = offset
				GameState.SetStep(2)
				$Bg/VBox/Start.disabled = false
				Debugger.CompleteAction()
			else:
				$Bg.rect_position = offset
			$Bg.rect_rotation = _getAngle()
	elif GameState.Step > 2:
		_startPressed()


func EnableSaveFile():
	GameState.ShowSave = true
	$Bg/VBox/Divide/Files/Main/Button.show()

func HideAllPanels():
	$Bg/VBox/Divide/Files.hide()
	$Bg/VBox/Divide/Settings.hide()
	$Bg/VBox/Divide/About.hide()
	$Bg/VBox/Divide/Market.hide()
	$Bg/VBox/Divide/ExitConfirm.hide()

func ShowPanel(panel):
	var ena = panel.visible
	HideAllPanels()
	panel.visible = not ena


func _getAngle():
	return -fmod(offset.length()/10, 360)


func _onNewGame():
	if GameState.Step == 4:
		GameState.SetStep(5)
	elif GameState.Step == 5:
		GameState.SetStep(6)
	elif GameState.Step == 8:
		GameState.LoadScene(Enums.scene.Lv1)
	
	if GameState.Step > 3 and GameState.Step < 8:
		Debugger.AddToHistory(" Missing resource file button_icon.png!", Debugger.TALKER.Error)

func _onLoadGame():
	ShowPanel($Bg/VBox/Divide/Files)

func _onSettings():
	ShowPanel($Bg/VBox/Divide/Settings)

func _onAbout():
	ShowPanel($Bg/VBox/Divide/About)
	if GameState.Step < 8:
		$Oregano.visible = true

func _onStore():
	ShowPanel($Bg/VBox/Divide/Market)

func _onExitRequest():
	if $Bg/VBox/Divide/Buttons/Exit.button_mask == 2:
		$Bg/VBox/Divide/Buttons/Exit.button_mask = BUTTON_MASK_LEFT
		$Bg/VBox/Divide/Buttons/Settings.disabled = false
		GameState.Settings = true
	else:
		$Bg/VBox/Divide/Buttons/Exit/Confirm.popup_centered()

func _onExit():
	GameState.LoadScene(Enums.scene.Splash)

func _startPressed():
	$Bg/VBox/Divide/Settings.Initialize()
	$Bg/VBox/Start.hide()
	$Bg/Fade.hide()
	$Bg/VBox/Divide.show()

func _onSavedGamePressed():
	if GameState.Step == 6:
		GameState.SetStep(7)
		Debugger.CompleteAction()
