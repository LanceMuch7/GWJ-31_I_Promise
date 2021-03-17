extends TextureRect

var slctd = false
var hovering = false
onready var staticPos = rect_position


func _ready():
	connect("gui_input", self, "_onGUI")
	connect("mouse_entered", self, "_onHover")
	connect("mouse_exited", self, "_onLeave")


func _onGUI(event:InputEvent):
	if hovering and event is InputEventMouseButton:
		slctd = event.is_pressed()
	elif slctd and event is InputEventMouseMotion:
		rect_global_position = get_tree().current_scene.get_global_mouse_position() - rect_size/2
		pass

func _onLeave():
	hovering = false

func _onHover():
	hovering = true
