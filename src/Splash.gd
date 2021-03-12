extends Control

signal stepped

# Scene refs
export (PackedScene) var next_scene
var next_scene_instance = null

# Object refs
onready var animPlr = get_node("AnimPlayer")

var loaded = false
var splashmode = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# connect to timer
	connect("stepped", self, "_onNextStep")
	$AnimPlayer.play("GHG_Splash")
	loaded = true
	Input.set_custom_mouse_cursor(GameState.Cursors[Enums.CURSORS.Default])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not loaded: return
	elif 1 < splashmode and splashmode < 99:
		load_scene()
		return
	elif not $AnimPlayer.is_playing():
		animFinished()

# 
func load_scene():
	splashmode = 999
	GameState.LoadChapter(next_scene)

func _onNextStep():
	if splashmode < 1:
		splashmode = 9
		load_scene()
	elif splashmode < 10:
		load_scene()

func animFinished():
	splashmode = 9

# 
func _input(event):
	if splashmode > 100: return
	if event.is_action_released("ui_accept") or event.is_action_released("ui_select"):
		animFinished()
		load_scene()
