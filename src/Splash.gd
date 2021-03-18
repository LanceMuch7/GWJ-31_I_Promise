extends Control

export (Enums.scene) var next_scene = Enums.scene.Title
var splashmode = 0


func _ready():
	if GameState.Step > 0:
		$container/Game/Title2.hide()
		$container/Game/Title.bbcode_text = "[center]I Promise[/center]"
	if GameState.Step < 10:
		$AnimPlayer.play("GHG_Splash")
		$AnimPlayer.connect("animation_finished", self, "load_scene")
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
	if event.is_action_released("ui_accept") or event.is_action_released("ui_select"):
		load_scene()
