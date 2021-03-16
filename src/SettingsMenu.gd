extends PanelContainer

signal ButtonToggled


func _ready():
	pass
	# @TODO: FIX ALL $ REFERENCES
	# Initialize option values


func _emit(prop, pressed):
	var btn = get_parent().get_node("Buttons/"+prop)
	
	btn.disabled = not pressed
#	emit_signal("ButtonToggled", prop, pressed)


func _onMarketToggled(button_pressed):
	_emit("Store", button_pressed)

func _onAboutToggled(button_pressed):
	_emit("About", button_pressed)

func _onExtToggled(button_pressed):
	_emit("Exit", button_pressed)

func _onLoadToggled(button_pressed):
	_emit("LoadGame", button_pressed)
