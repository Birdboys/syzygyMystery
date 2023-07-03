class_name defaultObject

var name = null
var alias = [name]
var been_examined = false
var in_inventory = false
var takeable = false
var examine_text_id = 0

func _init(n, al, ex=false,inv=false,take=false):
	name = n
	alias = al
	been_examined = ex
	in_inventory = inv
	takeable = take
	
func examine():
	return [name, examine_text_id]
	
func take():
	if takeable and not in_inventory:
		in_inventory = true
		return true
	else:
		return false

func use():
	pass
	
func isObject(token):
	return token in alias
