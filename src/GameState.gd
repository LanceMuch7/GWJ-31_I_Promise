extends Node

signal scene_changing
signal changed_scene

const Cursors = {
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

var Player

func LoadScene(scn):
	get_tree().change_scene_to(Scenes[scn])
