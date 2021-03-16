extends Control

const LINE = preload("res://src/DebugLine.tscn")
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
	[""],
	[""],
	[""],
	[""],
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


func AddToHistory(txt:String, player=false):
	var ln = LINE.instance()
	
	ln.get_node("text").text = txt
	history.add_child(ln)
	history.move_child(ln, 0)
	if player:
		$bg/Rows/LineEdit.text = ""
	else:
		ln.get_node("path").text = "[Gifthammer] "
	
	if not open:
		unread = true
		$bg/Toggle.icon = GameState.Cursors[Enums.Cursor.Alert]
	_setupNext(player)

func CompleteAction():
	_queueTimer()


func _queueTimer():
	$Timer.start()

func _setupNext(isPlayer=false):
	var step = GameState.Step
	
	if isPlayer:
		if step == 0:
			GameState.SetStep(1)
			_queueTimer()
	else:
		if step == 0 and RespIdx < responses[step].size()-1:
			RespIdx += 1
			_queueTimer()
		elif step == 1 and RespIdx < responses[step].size()-1:
			RespIdx += 1
			_queueTimer()
		elif step == 2:
			GameState.SetStep(3)


func _onToggled():
	open = not open
	if open:
		$AnimationPlayer.play("Show")
		$bg/Toggle.icon = null
	else:
		$bg/Rows/LineEdit.release_focus()
		$AnimationPlayer.play("Hide")

func _onSubmitted(new_text):
	AddToHistory(new_text, true)

func _onTimeout():
	AddToHistory(responses[GameState.Step][RespIdx])
