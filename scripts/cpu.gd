class_name CPU
extends Base

#каким игроком управлять
var player
#Юнит который сеяас ходит
var unitMove

func run(delta):
	
	
	var que:Queue=game.queue
	
	#============Выбор игрока которым играть
	
	var thisP:Player=que.getThisPlayer()
	if thisP!=null:
		if thisP.type==Player.TYPE_CPU:
			player=thisP
	
	
	#=============Управление игроком
	if player!=null:
		if game!=null:
			
			if que!=null:
				if que.isThisPlayPlayer(player):
					var units:Units=game.map.units
					
					#======Нужно управлять игроком
					
					
					var tileFrom=null
					var tileTo=null
					
					if unitMove==null:
						
						var unitsCpu=units.getUnitsPlayer(player,false,1)
						if unitsCpu!=null && unitsCpu.size()>0:
							
							var unitCpu=unitsCpu[0]
							
							
							var unitPlayer=null
							
							if unitCpu.name=="worm":
								
								#============Играть за червя
								#==========Просто идти к направлдению первого юнита врага
								var unitsPl=units.getUnitsOtherPlayer(player,1)
								if unitsPl!=null && unitsPl.size()>0:
									#Идем к этому юниту
									unitPlayer=unitsPl[0]
									
									#=====Проложить маршрут к юниту игрока
									tileFrom=unitCpu.getUnitTileCenter()
									tileTo=unitPlayer.getUnitTileCenter()
									
								else:
									#нету4 юнитов противника
									
									units.checkEndedAfterEnd(player)
									pass
									
									
							if unitCpu.name=="harvestr":
								#==============Играть за хавестра
								
								#поиск спайса
								if unitMove==null:
									var tileUnit=game.map.manMap.getCooTile(unitCpu.getCooUnitInMap())
									if tileUnit!=null:
										#====Взять спайс если на спайсе
										if game.map.manMap.isTileSpice(tileUnit.x,tileUnit.y):
											unitCpu.takeSpace()
										#====поиск нового спайса
										var tileSpice=game.map.manMap.searchTileSpice(tileUnit)
										
										if tileSpice!=null:
											#Идти к спайсу
											var hoSteps=unitCpu.getStepsByPoint(player.points)
											if hoSteps!=null:
												if hoSteps[0]>0:
													
													var route=unitCpu.navigator.buildRoute(unitCpu.getCooUnitInMap(),game.map.manMap.cooTileInPix(tileSpice),true,-1,true,unitCpu)
													unitCpu.moveOnRoute(route,hoSteps[0],0)
													#unitCpu.moveToTile(game.map.manMap.cooTileInPix(tileSpice),hoSteps[0])
													
													player.minusPoints(hoSteps[1])
													
													unitMove=unitCpu

												else:
													unitCpu.ended=true	
											else:
												unitCpu.ended=true	
										else:
											unitCpu.ended=true	
											
											#Спайст не найден
											
											pass
									else:
										unitCpu.ended=true	
										
									
								pass
								
							#===============================Ходить если нужно
							if tileFrom!=null && tileTo!=null:
								
								var route=unitCpu.navigator.buildRoute(tileFrom,tileTo,false,-1,true,unitCpu,[unitPlayer])
								if route!=null:
									
									#========Проверка ограничений
									if player.points>0:
										
										#На скольок можно ходить
										var hoSteps=unitCpu.getStepsByPoint(player.points)
										if hoSteps!=null && hoSteps[0]>0:
											
											if route.tiles.size()>1:
												
												unitCpu.moveOnRoute(route,hoSteps[0],1)
												player.minusPoints(hoSteps[1])
												
												unitMove=unitCpu
											
											else:
												endThisUnit(unitCpu)
											pass
									
									else:
										#Нету очков, конец хода для юнита
										endThisUnit(unitCpu)
								else:
									#Невозможно посториить маршрут
									
									endThisUnit(unitCpu)
						else:
							
							#Уже нету юнитов для хода
							pass
					else:
						
						#===============Юнит передвигается
						
						
						if unitMove.isRunning()==false:
							#===завершение хода юнита
							endThisUnit(unitMove)
							
							
					
					#проверка конца хода		
					units.checkEndTurnByPlayer(player)
					pass
					
				pass
	
	pass
	
#Завершить ход юнитом
func endThisUnit(unitCpu):
	var units:Units=game.map.units
	checkAttack(unitCpu,units)
	unitCpu.ended=true
	unitMove=null
	pass
	
	
#Провекра атаки
func checkAttack(unit,units):
	if unit!=null && unit.isRunning()==false:
		#======Проверка таки
		if unit.name=="worm":
			var unitsPl=units.getUnitsOtherPlayer(player,1)
			if unitsPl!=null && unitsPl.size()>0:
				#Идем к этому юниту
				var unitPlayer=unitsPl[0]
				unit.attackToUnit(unitPlayer)
	pass

func _init(game).(game):
	pass


