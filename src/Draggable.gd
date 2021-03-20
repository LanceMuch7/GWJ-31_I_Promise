extends TextureRect

var slctd = false
var overBtn = false
onready var staticPos = rect_position


func _ready():
	connect("gui_input", self, "_onGUI")


func _checkDist() -> bool:
	var btn = get_parent().get_node("Bg/VBox/Divide/Buttons/NewGame")
	var bcen = btn.rect_global_position + btn.rect_size/10
	
	if (rect_global_position - bcen).length() < 30:
		return true
	return false


func _onGUI(event:InputEvent):
	if event is InputEventMouseButton:
		slctd = event.is_pressed()
		
		if GameState.Step == 7 and not event.is_pressed() and _checkDist():
			get_parent().get_node("Bg/VBox/Divide/Buttons/NewGame").icon = texture
			GameState.PlayFixed = true
			GameState.SetStep(8)
			hide()
	elif slctd and event is InputEventMouseMotion:
		rect_global_position = get_tree().current_scene.get_global_mouse_position() - rect_size/2

func _onMouseEntered():
	overBtn = true

func _onMouseExited():
	overBtn = false
