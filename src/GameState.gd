extends Node

signal changed_scene

const Cursors = {
	Enums.Cursor.Alert: preload("res://Images/Sprites/exclamation.png"),
	Enums.Cursor.Cancel: preload("res://Images/Sprites/cancel.png"),
	Enums.Cursor.Default: preload("res://Images/Sprites/sword.png"),
	Enums.Cursor.Door: preload("res://Images/Sprites/door.png"),
	Enums.Cursor.Eye: preload("res://Images/Sprites/eye.png"),
	Enums.Cursor.Hand: preload("res://Images/Sprites/hand.png"),
	Enums.Cursor.Over: preload("res://Images/Sprites/over.png"),
	Enums.Cursor.Talk: preload("res://Images/Sprites/talk.png"),
}
const Scenes = {
	Enums.scene.Splash: preload("res://src/Splash.tscn"),
	Enums.scene.Title: preload("res://src/TitleMenu.tscn"),
}

# Using an int because godot can't increment an enum
#	0 = just began
#	1 = player responds to console
#	2 = title menu locked into place
#	3 = I acknowledge menu
#	4 = unlocked Settings
#	5 = 
#	6 = 
#	7 = unlocked other menus
#	8 = 
#	9 = 
var Step = 0
var Player


func _ready():
	var tmr = Timer.new()
	
	tmr.name = "LoadTimer"
	tmr.one_shot = true
	add_child(tmr)
	tmr.connect("timeout", self, "_onTimeout")


func LoadScene(scn):
	get_tree().change_scene_to(Scenes[scn])
	$LoadTimer.wait_time = 0.5
	$LoadTimer.start()

func SetStep(newStep):
	Step = newStep
	Debugger.RespIdx = 0


func _onTimeout():
	get_parent().move_child(get_tree().current_scene, 0)
