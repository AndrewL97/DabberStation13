var
  worldstarttime = 0
  worldstarttimeofday = 0

/mob/Stat() //human.dm line 147
	..()
	if (!worldstarttime || worldstarttimeofday)
		worldstarttime = world.time
		worldstarttimeofday = world.timeofday
	if(statpanel("Status"))
		if(ticker && istype(src,/mob/new_player))
			stat("Lobby",null)
			stat(null, "Gamemode : [ticker.mode ? ticker.mode.name : "Not Chosen"]")
		stat("Status",null)
		if(!STORM)
			if(istype(src,/mob/living))
				stat(null, "Nutrition : %[max(0,min(100,round(nutrition)))]")
				stat(null, "Thirst : %[max(0,min(100,round(thirst)))]")
				stat(null, "Weight : [round(weight,0.125)] KG")
		//stat(null, "Shield : %[round(shield)]")
		if(veh)
			stat("Vehicle Speed","[round(veh.velocity.SquareMagnitude()/50)] km/h")

	if(statpanel("Debugging information")) //Debug.
		var/tickdrift = (world.timeofday - worldstarttimeofday) - (world.time - worldstarttime)  / tick_lag_original
		stat("MAIN",null)
		stat(null, "Frame [frm_counter]")
		stat(null, "Bullets : [bullets.len]")
		stat(null, "Particles : [PARTICLE_LIST.len]")
		stat(null, "3D Position : [x], [round(heightZ)], [y]")
		stat(null, "Server tick usage : %[world.tick_usage]")
		stat(null, "Missed Ticks (lag) : [tickdrift]")
		if(master_controller)
			stat("MASTER",null)
			stat(null, "Master timer : [master_controller.wait]")
			stat(null, "Actions done : [actions_per_tick]")
			stat(null, "Processed : [master_Processed]")
			stat(null, "Max actions : [round(max_actions - ((max(0,min(world.cpu,100))/100)*(max_actions/2)*(CPU_warning)))][CPU_warning ? " (THROTTLED)" : ""]")
		if(air_master)
			stat("ATMOS",null)
			stat(null, "Processed : [atmos_processed]")
			stat(null, "Actions done : [actions_per_tick_atmos]")
			stat(null, "Max actions : [max_actions_atmos]")
		if(water_master)
			stat("WATER",null)
			stat(null, "Processed : [water_processed]")
			stat(null, "Actions done : [actions_per_tick_water]")
			stat(null, "Max actions : [round(max_actions_water - ((max(0,min(world.cpu,50))/50)*(max_actions_water/1.5)))]")