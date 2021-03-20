extends Node2D


func _init():
	$plr/Cutscene/Anim.play("BeginClip")


func _on_Anim_finished(anim_name):
	Debugger.AddToHistory(" unhandled exception \"\" ", Debugger.TALKER.Error)
	GameState.SetStep(10)
	GameState.LoadScene(Enums.scene.Splash)
