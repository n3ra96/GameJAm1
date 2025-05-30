extends Control

var player_name: String = ""
var selected_mode: String = ""

@onready var name_input = $Panel/VBoxContainer/NameInput
@onready var option1_button = $Panel/VBoxContainer/Option1Button
@onready var option2_button = $Panel/VBoxContainer/Option2Button
@onready var start_button = $Panel/VBoxContainer/StartButton

func _ready():
	name_input.text_changed.connect(_on_name_changed)
	option1_button.pressed.connect(_on_option1_pressed)
	option2_button.pressed.connect(_on_option2_pressed)
	start_button.pressed.connect(_on_start_pressed)
	
	# Initialize buttons state
	option1_button.set_toggle_mode(true)
	option2_button.set_toggle_mode(true)

func _on_name_changed(new_text: String):
	player_name = new_text
	_update_start_button()

func _on_option1_pressed():
	selected_mode = "arabic"
	option1_button.button_pressed = true
	option2_button.button_pressed = false
	_update_start_button()

func _on_option2_pressed():
	selected_mode = "hebrew"
	option1_button.button_pressed = false
	option2_button.button_pressed = true
	_update_start_button()

func _update_start_button():
	start_button.disabled = player_name.strip_edges().is_empty() or selected_mode.is_empty()

func _on_start_pressed():
	# Store the player name and selected mode in autoload/singleton if you have one
	# For now, we'll print it and load the main game scene
	print("Starting game with player: ", player_name, " in mode: ", selected_mode)
	# You can store these values in a global script or pass them as parameters
	# when loading the main game scene
	get_tree().change_scene_to_file("res://bar_level.tscn") 
