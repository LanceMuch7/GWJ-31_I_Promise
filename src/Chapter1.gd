extends Node2D


func _on_Anim_finished(anim_name):
	if anim_name == "BeginClip":
		$plr/Cutscene/Anim.play("Credits")
		Debugger.AddToHistory(" unhandled exception \"\" ", Debugger.TALKER.Error)
	else:
		print("Back to splash")
#		GameState.SetStep(9)
#		GameState.LoadScene(Enums.scene.Splash)
#		Debugger.CompleteAction()

func _on_Timer_timeout():
	$plr/Cutscene/Anim.play("BeginClip")
