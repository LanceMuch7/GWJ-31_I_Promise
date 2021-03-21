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
	TALKER.Error: "Error: ",
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
		"Wait what's wrong with my menu buttons!?"
	],
	[ # part 4
		"Huh, not sure why I forgot to add a Play button line item",
		"Here. This will fix it...",
		"SetEnabled Bg/VBox/Divide/Buttons/NewGame true",
		"Grrr... more errors. Oh wait, duh.",
		"SetUiEnabled Bg/VBox/Divide/Buttons/NewGame true",
	],
	[ # part 5
		"Gahhhh! Ok, not to worry! Just reboot the game and see if the error goes away. You should be all set to play after that."
	],
	[ # part 6
		"Nooo... I was sure we had it that time",
		"Listen, I'm really sorry this is taking so long, but I PROMISE you'll enjoy the game once we get you there!",
		"I've got one sure fire way left. I accidently left my old save file from my testing when I published the game. Check the LOAD screen in a sec."
	],
	[ # part 7
		"I... I give up...",
		"No! I shouldn't do that yet, just give me some time to figure out a way around this.",
		"Feel free to keep poking around yourself. Maybe you'll find something that I missed again."
	],
	[ # part 8
		"Oh! you--wait. What? How does that even make--",
		"I really should have listened to Grandma more often... Anyways, enjoy!"
	],
	[ # part 9
		"A boot-loop? Really? Ughhhh why now?",
		"...I don't think there's any way to recover from this",
		"Well, thanks for trying to play anyways. I really appreciate it, and sorry it was so awful",
		"Hey you know what, since this has been such a disaster, why don't I tell you a story instead? We still have this loading screen, and I bet I can whip up a drawing to go with it",
		"What do you say? I understand if you want to quit and leave this dumpster fire behind..."
	],
	[ # part 10
		"Great! Ok give me a moment to think..."
	]
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
	
	ln.get_node("path").text = prefixes[talker]
	ln.get_node("text").text = txt
	if talker == TALKER.Error:
		ln.get_node("text").self_modulate = Color.salmon
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
				AddToHistory(" Command  'setenabled'  not recognized", TALKER.Error)
		TALKER.GH:
			if step == 0 and RespIdx < responses[step].size()-1:
				RespIdx += 1
				_queueTimer()
			elif step == 1 and RespIdx < responses[step].size()-1:
				RespIdx += 1
				_queueTimer()
			elif step == 2:
				GameState.SetStep(3)
				_queueTimer()
			elif step == 4 and RespIdx == 0:
				RespIdx += 1
				_queueTimer()
			elif step == 4 and (RespIdx == 1 or RespIdx == 3):
				RespIdx += 1
				_onSubmitted(responses[GameState.Step][RespIdx])
			elif step >= 5 and step <= 9 and RespIdx < responses[step].size()-1:
				RespIdx += 1
				_queueTimer()
			elif step == 6 and RespIdx == 2:
				get_tree().current_scene.EnableSaveFile()
		TALKER.Error:
			if step == 5 and RespIdx == 0:
				_queueTimer()
			elif step == 6 and RespIdx == 0:
				_queueTimer()
		TALKER.Console:
			if step == 9999:
				_queueTimer()

# Execute the provided command if valid
func _parseCmd(txt:String):
	var args = txt.split(" ", false)
	
	match args[0].to_lower():
		"help":
			AddToHistory("""Valid commands:

Help                             - Prints out this list of commands and descriptions.
Give <actorId> <assetId> <int>   - Gives <int> copies of assetId to the specified actorId.
SetQuestStep <int>               - Progresses the currently active quest to the step specified.
ReloadScene                      - Reloads the current scene from fresh to fix some display bugs.
SetUiEnabled <path> <bool>       - Forces a UI button enabled or disabled given a valid node path.
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
		"setuienabled":
			if get_tree().current_scene.has_node(args[1]):
				get_tree().current_scene.get_node(args[1]).disabled = not bool(args[2])


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
	if GameState.Step == 9:
		var low = new_text.to_lower()
		if low.find("yes") >= 0 or low.find("sure") >= 0 or low.find("ok") >= 0:
			GameState.SetStep(10)
			CompleteAction()
	if cmd:
		_parseCmd(new_text)

func _onTimeout():
	AddToHistory(responses[GameState.Step][RespIdx])
