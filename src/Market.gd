extends PanelContainer

var sawCurrency = false


func _init():
	sawCurrency = GameState.SawCrncyPage


func _onButtonPressed():
	Debugger.AddToHistory("Unable to perform action GET on https://server.doesnotexist.dne/query?=GET", Debugger.TALKER.Error)

func _on_Currency_Seen(idx:int):
	if not sawCurrency and idx == 2:
		Debugger.AddToHistory("Ok, I know how this looks, but I can explain. Marketplace items only give players a MODEST gameplay bonus, and you can earn Love Points by playing if you want. Also, players can unlock a 10% discount on the bottom 3 currency options after completing the first level!", Debugger.TALKER.GH)
		sawCurrency = true
		GameState.SawCrncyPage = sawCurrency
