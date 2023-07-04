class_name defaultObject

var name = null
var alias = [name]
var been_examined = false
var in_inventory = false
var takeable = false
var look_text_id = 0
var look_preps = []

func _init(n, al, p=[], ex=false,inv=false,take=false):
	name = n
	alias = al
	been_examined = ex
	in_inventory = inv
	takeable = take
	look_preps = p
	
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
	
func look(prep):
	if prep in look_preps:
		return [name, look_text_id, prep]
	else:
		return [name, look_text_id, null]
