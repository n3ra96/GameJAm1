extends Panel

@onready var original_text = $VBoxContainer/OriginalTextPanel/HBoxContainer/OriginalText
@onready var speaker_button = $VBoxContainer/OriginalTextPanel/HBoxContainer/SpeakerButton
@onready var audio_manager = $DialogueAudio

func _ready():
	speaker_button.pressed.connect(_on_speaker_button_pressed)

func _on_speaker_button_pressed():
	if audio_manager:
		audio_manager.play_sentence(original_text.text) 
