class_name defaultRoom

#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]
var look_text_id = 0
var name = null #name of the room
var adjacent = [] #adjacent rooms that can be moved to
var outside = false #is room outside
var objects = [] #objects in room that can be interacted with

var look_text = null
var object_text_path = 'res://Assets/texts/%s/%s.json'

func _init(n, adj, out, obj, lt):
	name = n
	adjacent = adj
	outside = out
	objects = obj
	look_text = lt

func isRoomConnected(room):
	return room in adjacent or room == name

func isObjectInRoom(obj_name, prep):
	for obj in objects: #go through every object
		if obj.isObject(obj_name): #if the object is in the room
			return obj.look(prep) #return look stuff for text
	return null

