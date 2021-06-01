extends Node

var queue: GDScriptFunctionState
var ind: String = ''
var arr = ['1','2','3','4','5','6']
var timing = [2,1,0.5,0.1,2,0.2]
var func_arr = []

var thread1

export(Array, Dictionary) var dict

func test(inx: int = 0, id = null):
	if func_arr.size() < arr.size():
		queue = test2(inx, id)
		func_arr += [queue]
		print(queue)
	
func test2(inx: int = 0, id = null):
	print('Call: ', inx, ' waiting for ', queue)
	if queue:
		yield(queue, 'completed')
	ind += arr.pop_front()
	yield(get_tree().create_timer(timing.pop_front()),"timeout")
	if id:
		prints(id, ind)
	else:
		print(ind)
#	if inx == 5:
#		for i in func_arr:
#			i.unreference()
#		print(func_arr[5].is_valid())
#	queue =  null

func test_numbers(id = null):
	test(0, id)
	test(1, id)
	test(2, id)
	test(3, id)
	test(4, id)
	test(5, id)

func _ready():
	thread1 = Thread.new()
	# Third argument is optional userdata, it can be any variable.
	thread1.start(self, "test_numbers", thread1.get_id())
#	print("arr.has ", arr.has(['1','2','3']))
	test_numbers()

func _exit_tree():
	thread1.wait_to_finish()
