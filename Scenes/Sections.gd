extends Node2D

@export var roomtext = {
	"Start" : {
		title = "The Entrance to the Mines",
		description =
"""[color=#fff9d3]You are a young worker dwarf[/color] residing in the mining section of an underground kingdom.
Recently you were approached by some fellow workers, who [color=#fff9d3]invited you to join a rebellion[/color] against the royalty forcing you to work so hard for so little.
You agreed that your work is hard and you don't have much to show for it, so [color=#fff9d3]you agree to join them.[/color]
[color=#fff9d3]Your mission is to deliver a scroll to the King[/color], the workers tell you that if you make the King read it he will be forced to obey the demands it contains.
They also tell you that [color=#fff9d3]the King knows of their plan[/color], and his guards will be on the lookout for people bearing scrolls.
	[i]\"[color=#fff9d3]Don't read the scroll[/color], or its magic will be wasted on you, and the mission failed. Here's a makeshift knife you can use as a weapon until you can take one from a guard\"[/i]
..and with that said they send you off. Laughing with glee over the prospect of your mutual future freedom[color=#fff9d3]?[/color]
"""
	},
	"PreArmory" : {
		title = "Guard Armory Corridor",
		description = """You find yourself in an L-shaped hallway with two doors at either end, one is locked, but the other isn't, and you can hear voices inside.
The voices probably belong to the guards charged with watching over the locked door...
""",
	},
	"GuardHouse" : {
		title = "Guard Quarters",
		description = """You open the door to see three guards playing cards at a table. Their eyes widen as they spot the weapon in your hand and they fumble for their own.
You have the advantage of surprise for the duration of this fight
"""
	},
	"ArmoryHall" : {
		title = "Guard Armory Corridor",
		description = """You use the key from the guards you killed to open the locked door. It leads to a hallway with two doors that open to armory storage, and ends at the entrance to an underground river, where a boat is docked.
A search of the armory storage gets you a better weapon and some healing potions""",
	},
	"WaterEntrance" : {
		title = "Entrance to the Royal UnderPalace",
		description = """You float down the river until you come across a dock sporting a sign that says:
	[i]\"His Majesty's Royal Underpalace (Servant Entrance)\"[/i]
You tie your boat at the dock and head through the door it connects to. You find yourself in a small stone cellar, to the north and up a small flight of stairs is a door.
""",
	},
	"FoodHall" : {
		title = "Banquet Hall",
		description = """You find yourself in a banquet hall with a large wooden table and a throne at one end.
You see a door to the north, and a hallway to the east, which has a locked door to the north, labeled 'Treasury', a door to the south, and a long corridor heading east"""
	},
	"Kitchens" : {
		title = "Kitchens",
		description = """You open the door and are greeted with a guard receiving a plate of food from a chef.
This guard seems well trained, and immediately springs into action when they see you hold a weapon.
The chef is not as good at overcoming their surprise, but follows suit, fumbling for a cleaver off of a nearby table.
"""
	},
	"TreasuryKey" : {
		title = "☃",
		description = """You enter a circular room with white powder peacefully falling from a seemingly nonexistent ceiling and collecting on the floor. It's cold to the touch, and melts in your hand.. Is this what the surfacedwellers call snow?
In the center of the room is a statue of a human, made partly of snow, with stick arms, eyes of stone, and a carrot for a nose. One of the arms holds a key, which you take.
"""
	},
	"LockedTreasury" : {
		title = "His Majesty's Treasury",
		description = "You enter an empty room, it looks like His Majesty is as well off as you are"
	},
	"BossHallway" : {
		title = "His Majesty's Hallway",
		description = """You find yourself in the most decorated hallway you've ever seen or dreamed of, to the north is the most decorated door you've ever seen or dreamed of.
To the east is a door slightly less well decorated than the door to the north.
""",
	},
	"BossGuards" : {
		title = "His Majesty's Royal Elite Guard Residences",
		description = """You reach for the door but see the knob is already turning, you draw your weapon and prepare to attack whoever is on the other side.
""",
	},
	"FinalBoss" : {
		title = "His Majesty's Majestical Royal Holy Chambers",
		description = """It is time.
With your scroll held out it front of you, you enter the room, and present it to a stunned king, who is sitting at their private dining table, with their back to a cozy fire.
""",
	},
}

func _ready():
	self.visible = true
	Audio.resume("Main")
	Audio.stop("Battle")

func moved_player():
	$Player.position = get_node(Settings.setting.player_pos).position

func _on_timer_timeout():
	get_node(Settings.setting.player_pos).on_arrival()

func _on_continuebutton_pressed():
	var n = Settings.setting.player_pos
	Audio.play("Select")

	if n == "GuardHouse":
		BattleInfo.start_battle(0, 16 * 3)
	elif n == "ArmoryHall":
		Settings.setting.player_inventory.append("Healing Potion")
		Settings.setting.player_inventory.append("Healing Potion")
	elif n == "TreasuryKey":
		get_node(n).emit_signal("trigger_unlock")
	elif n == "Kitchens":
		BattleInfo.start_battle(2, 16 * 2, ["Healing Potion"])
	elif n == "BossGuards":
		BattleInfo.start_battle(3, 14 * 3)
	elif n == "FinalBoss":
		Settings.setting = Settings.default_setting.duplicate(true)
		Settings.update()
		get_tree().change_scene_to_file("res://Scenes/EndScene.tscn")
