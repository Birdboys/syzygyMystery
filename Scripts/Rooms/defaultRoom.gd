class_name defaultRoom

#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]
var name = null #name of the room
var adjacent = [] #adjacent rooms that can be moved to
var outside = false #is room outside
var objects = [] #objects in room that can be interacted with


func _init(n, adj, out, obj):
	name = n
	adjacent = adj
	outside = out
	objects = obj

func isRoomConnected(room):
	print(room, adjacent)
	return room in adjacent or room == name
