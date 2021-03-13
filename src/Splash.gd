extends Control

export (Enums.scene) var next_scene = Enums.scene.Title
var splashmode = 0


func _ready():
	# connect to timer
	$AnimPlayer.play("GHG_Splash")
	$AnimPlayer.connect("animation_finished", self, "load_scene")

func load_scene(arg=null):
	splashmode = 999
	Input.set_custom_mouse_cursor(GameState.Cursors[Enums.Cursor.Default])
	GameState.LoadScene(next_scene)

func _input(event):
	if splashmode > 100: return
	if event.is_action_released("ui_accept") or event.is_action_released("ui_select"):
		load_scene()
