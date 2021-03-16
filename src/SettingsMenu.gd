extends PanelContainer

var gameList = {
	"Fullscreen": ["Fullscreen/HBox", "pressed", "_onSetFullscreen"],
	"Audio": ["Audio/HBox", "pressed", "_onDefaultInput"],
	"Volume": ["Volume/HBox", "value_changed", "_onDefaultSlide"],
	"FontSize": ["FontSize/HBox", "value_changed", "_onDefaultSlide"],
}
# @TODO: MORE LISTS


func _ready():
	# @TODO: INITIALIZE OPTIONS
	# Setup signals
	for option in $Container/List.get_children():
		if gameList.has(option.name):
			var data = gameList[option.name]
			
			option.get_node("HBox/Label").text = option.name
			option.get_node("HBox/Button").connect(data[1], self, data[2], [option.get_node("HBox/Button")])
	
	# @TODO: FIX ALL $ REFERENCES
	# Initialize option values
	if OS.window_fullscreen:
		$Main/List/Fullscreen/HBox/Button.pressed = true
	$Container/List/FontSize/HBox/Button.set_suffix("px")
