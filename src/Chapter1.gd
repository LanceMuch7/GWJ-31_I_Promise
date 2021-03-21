extends Node2D


func _on_Anim_finished(anim_name):
	Debugger.AddToHistory(" unhandled exception \"\" ", Debugger.TALKER.Error)
	GameState.SetStep(10)
	GameState.LoadScene(Enums.scene.Splash)

func _on_Timer_timeout():
	$plr/Cutscene/Anim.play("BeginClip")
