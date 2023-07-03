extends Node
@onready var look_text_path = "res://Assets/texts/look_texts.json"
@onready var look_text
@onready var examine_text_path = "res://Assets/texts/%s/%s.json"
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

func getExamineText(room_name, object_name, object_id):
	var object_examine_path = examine_text_path % [room_name, object_name]
	print(object_examine_path)
	if FileAccess.file_exists(object_examine_path): #we have data
		var obj_data = FileAccess.open(object_examine_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(obj_data.get_as_text())
		print(parsed_data)
		obj_data.close()
		if parsed_data is Dictionary:
			if object_id in parsed_data:
				return parsed_data[object_id]
			else:
				print("INVALID EXAMINE TEXT ID")
				return null
		else:
			print("some kinda object data loading error")	
	else:
		print("invalid object text path")
		return null
