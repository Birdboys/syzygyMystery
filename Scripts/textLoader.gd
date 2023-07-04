extends Node
@onready var look_text_path = "res://Assets/texts/%s/%s_look.json"
@onready var look_text
@onready var real_words
# Called when the node enters the scene tree for the first time.
func _ready():
	real_words = getRealWords()
	print(real_words)
	look_text = getRoomLookText(look_text_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getRoomLookText(save_path):
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

func getLookText(room_name, object_name, object_id, prep):
	var object_look_text_path = look_text_path % [room_name, room_name]
	prep = prep if prep else ""
	var look_text_id = "%s" % object_id if room_name == object_name else "%s%s%s" % [object_name, object_id, prep]
	print(look_text_id)
	#print(object_examine_path)
	if FileAccess.file_exists(object_look_text_path): #we have data
		var look_data = FileAccess.open(object_look_text_path, FileAccess.READ)
		look_data = JSON.parse_string(look_data.get_as_text())
		if look_data is Dictionary:
			if look_text_id in look_data:
				return look_data[look_text_id]
			else:
				print("INVALID LOOK TEXT ID")
				return null
		else:
			print("some kinda look data loading error")	
	else:
		print("invalid look text path")
		return null
func getRealWords():
	if FileAccess.file_exists("res://Assets/texts/real_words.json"): #we have data
	#var save_data = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, 'porbo')
		var save_data = FileAccess.open("res://Assets/texts/real_words.json", FileAccess.READ)
		var parsed_data = JSON.parse_string(save_data.get_as_text())
		save_data.close()
		if parsed_data is Dictionary:
			return parsed_data
		else:
			print("some kinda system data loading error")	
	else:
		print("invalid look text path")
		return {}
