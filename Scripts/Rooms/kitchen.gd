extends defaultRoom
class_name kitchenRoom
#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]

func _init():
	name = 'entry'
	adjacent = ['kitchen','bathroom','bedroom']
	outside = false
	var fridge = defaultObject.new('refridgerator',['refridgerator', 'fridge', '`icebox'], true, [null,'at','in','on'])
	var freezer = defaultObject.new('freezer',['freezer'],true,[null,'at','in','on'])
	var cord = defaultObject.new('cord',['cord','wire'],false)
	cord.setTake([null,'at','in'],[null,'freezer'], 'take_freezer_wire')
	var calendar = defaultObject.new('calendar',['calendar'],true,[null,'at','behind'])
	var counter = defaultObject.new('counter',['counter','island','coutertop'],true,[null,'at','on'])
	var trash = defaultObject.new('trash',['trash','bin','rubbish','trashcan'],true,[null,'at','in'])
	var photo = defaultObject.new('photo',['photos','photo','picture','pictures','image','images'],true)
	objects = [fridge, freezer, cord, calendar, counter, trash, photo]


