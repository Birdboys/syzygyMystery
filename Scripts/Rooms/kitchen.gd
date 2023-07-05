extends defaultRoom
class_name kitchenRoom
#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]

func _init():
	name = 'kitchen'
	adjacent = ['lounge','bathroom','bedroom']
	outside = false
	var fridge = defaultObject.new('refridgerator',['refridgerator', 'fridge', '`icebox'],'kitchen', true, [null,'at','in','on'])
	var freezer = defaultObject.new('freezer',['freezer'],'kitchen',true,[null,'at','in','on'])
	var cord = defaultObject.new('cord',['cord','wire'],'kitchen',false)
	cord.setTake([null,'at','in'],[null,'freezer'], 'take_freezer_wire')
	var calendar = defaultObject.new('calendar',['calendar'],'kitchen',true,[null,'at','behind'])
	var counter = defaultObject.new('counter',['counter','island','coutertop'],'kitchen',true,[null,'at','on'])
	var trash = defaultObject.new('trash',['trash','bin','rubbish','trashcan'],'kitchen',true,[null,'at','in'])
	var photo = defaultObject.new('photo',['photos','photo','picture','pictures','image','images'],'kitchen',true)
	objects = [fridge, freezer, cord, calendar, counter, trash, photo]


