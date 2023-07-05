class_name defaultObject

var name = null
var room = ""
var alias = [name]
var been_examined = false
var in_inventory = false
var takeable = false
var look_text_id = ""
var look_preps = []
var take_text_id = ""
var take_preps = []
var take_item = []
var take_signal
var discoverable = true

func _init(n, al, r, dis=true, p=[null,'at']):
	name = n
	alias = al
	room = r
	look_preps = p
	discoverable = dis

func setTake(preps, item, take_s):
	take_preps = preps
	take_item = item
	takeable = true
	take_signal = take_s
	
func use():
	pass
	
func isObject(token):
	return token in alias
	
func look(prep):
	if not discoverable:
		return null
	if prep in look_preps:
		return [name, look_text_id, prep]
	else:
		null

func take(prep, indirect):
	if not discoverable:
		return null
	elif in_inventory: #if already in inventory
		return ["-1", name]
	elif prep in take_preps and indirect in take_item:
		var ret = [name, take_text_id, prep]
		in_inventory = true
		look_text_id = "inv"
		EventListener.processEvent(take_signal)
		return ret
	else:
		return null
		
