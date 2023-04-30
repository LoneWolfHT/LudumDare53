extends Control

@export_file("*.tscn") var _main_path: String

@onready var reroll_button = $Tray/Reroll
@onready var done_button = $DoneButton
@onready var battle_log = $BattleLog
@onready var battle_stats = $BattleStats
@onready var sum_label = $SumLabel
@onready var player_hp = $PlayerHP
@onready var enemy_hp = $EnemyHP

@onready var dice = $Tray/Dice
@onready var dice2 = $Tray/Dice2
@onready var dice3 = $Tray/Dice3

var rng = RandomNumberGenerator.new()

var done_action = "none"
var tries = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	done_button.visible = false
	Audio.stop("Main")
	Audio.resume("Battle")

	battle_stats.text = "You need to roll %d or higher to hit" % (8 + BattleInfo.enemy_count)

	reroll_button.text = "Reroll (x%d)" % tries

	enemy_hp.max_value = BattleInfo.enemy_hp
	enemy_hp.value = BattleInfo.enemy_hp
	enemy_hp.tooltip_text = "%d HP left" % enemy_hp.value

	player_hp.max_value = Settings.setting.player_hp_max
	player_hp.value = Settings.setting.player_hp
	player_hp.tooltip_text = "%d HP left" % player_hp.value

	rng.randomize()

	Audio.play("Dice")
	dice.frame = randi_range(0, 5)
	dice2.frame = randi_range(0, 5)
	dice3.frame = randi_range(0, 5)

	var sum = (dice.frame + dice2.frame + dice3.frame + 3) - (9 + BattleInfo.enemy_count)
	sum_label.bbcode_text = "[center]%d + %d + %d - (9 + %d) = [color=%s]%d x 2[/color][/center]" % [
		dice.frame+1, dice2.frame+1, dice3.frame+1, BattleInfo.enemy_count,
		"green" if sum >= 0 else "red",
		sum
	]

func _on_reroll_pressed():
	if tries <= 0:
		return

	tries -= 1
	reroll_button.text = "Reroll (x%d)" % tries

	Audio.play("Dice")
	Audio.play("Select")
	dice.frame = randi_range(0, 5)
	dice2.frame = randi_range(0, 5)
	dice3.frame = randi_range(0, 5)

	var sum = (dice.frame + dice2.frame + dice3.frame + 3) - (9 + BattleInfo.enemy_count)
	sum_label.bbcode_text = "[center]%d + %d + %d - (9 + %d) = [color=%s]%d x 2[/color][/center]" % [
		dice.frame+1, dice2.frame+1, dice3.frame+1, BattleInfo.enemy_count,
		"green" if sum >= 0 else "red",
		sum
	]

func _on_accept_pressed():
	var sum = dice.frame + dice2.frame + dice3.frame + 3

	sum = sum - (9 + BattleInfo.enemy_count)
	sum *= 2

	if sum == 0:
		battle_log.text = "Your weapons clash, but no damage is dealt"
		Audio.play_low("Good", -4)
	elif sum > 0:
		Audio.play("Good")
		enemy_hp.value -= sum
		enemy_hp.tooltip_text = "%d HP left" % enemy_hp.value

		if enemy_hp.value <= 0:
			Settings.setting.completed[Settings.setting.player_pos] = true

			battle_log.text = "You do a fancy twirl and dispatch the last enemy. Check your inventory to see if you found any items"
			done_button.text = "Victory"
			done_button.visible = true
			$Tray/Accept.visible = false
			battle_stats.visible = false
		else:
			battle_log.text = "You attack, and your enemy fails to block. You deal %dHP damage" % sum
	elif sum < 0:
		Audio.play("Bad")
		sum = abs(sum)

		player_hp.value -= sum
		player_hp.tooltip_text = "%d HP left" % player_hp.value
		Settings.setting.player_hp -= sum

		if player_hp.value <= 0:
			battle_log.text = "The enemy deals a death blow. Your mission has come to an abrupt end"
			done_button.text = "Restart Game"
			done_button.visible = true
			$Tray/Accept.visible = false
			battle_stats.visible = false
			$Tray/Cheat.set("theme_override_colors/font_color", Color.YELLOW)
			$Tray/Cheat.set("theme_override_font_sizes/font_size", 30)
		else:
			battle_log.text = "The enemy evades your attack and counters with one of their own: -%dHP" % sum

		Settings.update()

	Audio.play("Dice")
	dice.frame = randi_range(0, 5)
	dice2.frame = randi_range(0, 5)
	dice3.frame = randi_range(0, 5)

	sum = (dice.frame + dice2.frame + dice3.frame + 3) - (9 + BattleInfo.enemy_count)
	sum_label.bbcode_text = "[center]%d + %d + %d - (9 + %d) = [color=%s]%d x 2[/color][/center]" % [
		dice.frame+1, dice2.frame+1, dice3.frame+1, BattleInfo.enemy_count,
		"green" if sum >= 0 else "red",
		sum
	]

	if tries <= 1:
		tries = 2

	reroll_button.text = "Reroll (x%d)" % tries

func _on_done_button_pressed():
	Audio.play("Select")
	if player_hp.value <= 0:
		Settings.setting = Settings.default_setting.duplicate(true)
		Settings.update()

	for item in BattleInfo.rewards:
		Settings.setting.player_inventory.append(item)

	get_tree().change_scene_to_file(_main_path)

func _on_cheat_pressed():
	if player_hp.value <= 0:
		Audio.play("Good")
		player_hp.value = 1
		player_hp.tooltip_text = "%d HP left" % player_hp.value
		Settings.setting.player_hp = 1
		Settings.update()
		done_button.visible = false
		$Tray/Accept.visible = true
		battle_stats.visible = true
		$Tray/Cheat.set("theme_override_colors/font_color", Color.RED)
		$Tray/Cheat.set("theme_override_font_sizes/font_size", 24)
	else:
		Audio.play("Bad")
		tries += 10
		tries = clamp(tries, 0, 999)
		reroll_button.text = "Reroll (x%d)" % tries
