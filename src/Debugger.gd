extends Control

const LINE = preload("res://src/DebugLine.tscn")

enum TALKER {
	Player,
	GH,
	Error,
	Console
}
const prefixes = {
	TALKER.Player: " > ",
	TALKER.GH: "[Gifthammer]",
	TALKER.Error: "ERROR!",
	TALKER.Console: ""
}

var open = false
var unread = false
var responses = [
	[ # part 0
		"Hi? Hello? Are you still here?",
		"Just type anything to let me know you're reading this"
	],
	[ # part 1
		"Great! Ok, just bear with me a moment. I thought I had everything ready, but clearly there are a few bugs to work out. Just keep playing and I'll try to stay ahead of you with the fixes.",
		"Wait, where is my title menu?",
		"Hm, I though for sure I had it this time... maybe it's src/UI/Title.tscn?",
	],
	[ # part 2
		"Oh you found it! Huh... no idea how it got all the way over there"
	],
	[ # part 3
		""],
	[ # part 4
		"Huh, not sure why I forgot to add a Play button line item",
		"Here. This will fix it...",
		"SetUiEnabled Bg/VBox/Divide/Buttons/NewGame true",
		"Grrr... more errors",
	],
	[ # part 5
		""],
	[ # part 6
		""],
	[""],
	[""],
	[""],
	[""]
]
var RespIdx = 0
onready var history = $bg/Rows/Scroll/Lines


func _input(event):
	if event.is_action_pressed("ui_select"):
		_onToggled()
	elif event.is_action_pressed("ui_cancel"):
		$bg/Rows/LineEdit.release_focus()


func AddToHistory(txt:String, talker=TALKER.GH):
	var ln = LINE.instance()
	
	ln.get_node("text").text = txt
	ln.get_node("path").text = prefixes[talker]
	history.add_child(ln)
	history.move_child(ln, 0)
	
	if talker == TALKER.Player:
		$bg/Rows/LineEdit.text = ""
	
	if not open:
		unread = true
		$bg/Toggle.icon = GameState.Cursors[Enums.Cursor.Alert]
	_setupNext(talker)

func CompleteAction():
	_queueTimer()


func _queueTimer():
	$Timer.start()

func _setupNext(talker=TALKER.GH):
	var step = GameState.Step
	
	match talker:
		TALKER.Player:
			if step == 0:
				GameState.SetStep(1)
				_queueTimer()
			elif step == 4 and RespIdx == 2:
				RespIdx += 1
				_queueTimer()
		TALKER.GH:
			if step == 0 and RespIdx < responses[step].size()-1:
				RespIdx += 1
				_queueTimer()
			elif step == 1 and RespIdx < responses[step].size()-1:
				RespIdx += 1
				_queueTimer()
			elif step == 2:
				GameState.SetStep(3)
			elif step == 4 and RespIdx == 0:
				RespIdx += 1
				_queueTimer()
			elif step == 4 and RespIdx == 1:
				RespIdx += 1
				_onSubmitted(responses[GameState.Step][RespIdx])
		TALKER.Error:
			if step == 9999:
				GameState.SetStep(1)
				_queueTimer()
		TALKER.Console:
			if step == 9999:
				GameState.SetStep(1)
				_queueTimer()

# Execute the provided command if valid
func _parseCmd(txt:String):
	var args = txt.to_lower().split(" ", false)
	
	match args[0]:
		"help":
			AddToHistory("""Valid commands:

Help                             - Prints out this list of commands and descriptions.
Give <actorId> <assetId> <int>   - Gives <int> copies of assetId to the specified actorId.
SetQuestStep <int>               - Progresses the currently active quest to the step specified.
ReloadScene                      - Reloads the current scene from fresh to fix some display bugs.
""", TALKER.Console)
		"give":
			pass
		"setqueststep":
			var step
			
			if args.size() > 1:
				step = args[1].to_int()
				GameState.SetStep(step)
		"reloadscene":
			get_tree().reload_current_scene()


func _onToggled():
	open = not open
	if open:
		$AnimationPlayer.play("Show")
		$bg/Toggle.icon = null
	else:
		$bg/Rows/LineEdit.release_focus()
		$AnimationPlayer.play("Hide")

func _onSubmitted(new_text, cmd=true):
	AddToHistory(new_text, TALKER.Player)
	if cmd:
		_parseCmd(new_text)

func _onTimeout():
	AddToHistory(responses[GameState.Step][RespIdx])
