extends Node
@onready var look_text_path = "res://Assets/texts/look_texts.json"
@onready var look_text
# Called when the node enters the scene tree for the first time.
func _ready():
	look_text = getLookText(look_text_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getLookText(save_path):
	if FileAccess.file_exists(save_path): #we have data
	#var save_data = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, 'porbo')
		var save_data = FileAccess.open(save_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(save_data.get_as_text())
		save_data.close()
		if parsed_data is Dictionary:
			return parsed_data
		else:
			print("some kinda system data loading error")	
	else:
		print("invalid look text path")
		return {}
