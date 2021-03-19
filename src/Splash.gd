extends Control

export (Enums.scene) var next_scene = Enums.scene.Title
var splashmode = 0


func _ready():
	if GameState.Step > 0:
		$container/Game/Title2.hide()
		$container/Game/Title.bbcode_text = "[center]I Promise[/center]"
	
	if GameState.Step < 10:
		$AnimPlayer.play("GHG_Splash")
	else:
		# Tell the player a story
		pass

func load_scene(arg=null):
	splashmode = 999
#	Input.set_custom_mouse_cursor(GameState.Cursors[Enums.Cursor.Default])
	GameState.LoadScene(next_scene)
	if GameState.Step == 0:
		Debugger.CompleteAction()
		Debugger.get_node("AnimationPlayer").play("PopoutButton")

func _input(event):
	if splashmode > 100: return
	if event.is_action_released("ui_accept"):
		_on_AnimPlayer_animation_finished($AnimPlayer.current_animation)

func _on_AnimPlayer_animation_finished(anim_name):
	match anim_name:
		"GHG_Splash":
			$AnimPlayer.play("GWJ_Splash")
		"GWJ_Splash":
			$AnimPlayer.play("Game_Splash")
		"Game_Splash":
			load_scene()
