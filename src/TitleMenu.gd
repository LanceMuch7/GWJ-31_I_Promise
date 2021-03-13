extends Control


func HideAllPanels():
	$VBox/Divide/Files.hide()
	$VBox/Divide/Settings.hide()
	$VBox/Divide/About.hide()
	$VBox/Divide/Market.hide()
	$VBox/Divide/ExitConfirm.hide()


func _onNewGame():
	pass # Replace with function body.

func _onLoadGame():
	pass # Replace with function body.

func _onSettings():
	HideAllPanels()
	$VBox/Divide/Settings.show()

func _onAbout():
	pass # Replace with function body.

func _onStore():
	pass # Replace with function body.

func _onExit():
	if $VBox/Divide/Buttons/Exit.button_mask == 2:
		$VBox/Divide/Buttons/Exit.button_mask = BUTTON_MASK_LEFT
		$VBox/Divide/Buttons/Settings.disabled = false
	else:
		print("yes, the menu IS working")
		GameState.LoadScene(Enums.scene.Splash)
