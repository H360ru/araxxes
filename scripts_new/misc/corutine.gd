extends Node

var queue: GDScriptFunctionState
var ind: String = ''
var arr = ['1','2','3','4','5','6']
var timing = [6,1,0.5,0.1,2,0.2]
var func_arr = []

export(Array, Dictionary) var dict

func test(inx: int = 0):
	queue = test2(inx)
	func_arr += [queue]
	print(queue)
	
func test2(inx: int = 0):
	print('Call: ', inx, ' waiting for ', queue)
	if queue:
		yield(queue, 'completed')
	ind += arr.pop_front()
	yield(get_tree().create_timer(timing.pop_front()),"timeout")
	print(ind)
	if inx == 5:
		for i in func_arr:
			i.unreference()
		print(func_arr[5].is_valid())
#	queue =  null

func _ready():
	print("arr.has ", arr.has(['1','2','3']))
#	test(0)
#	test(1)
#	test(2)
#	test(3)
#	test(4)
#	test(5)
	
