var
  worldstarttime = 0
  worldstarttimeofday = 0

/mob/Stat() //human.dm line 147
	..()
	if (!worldstarttime || worldstarttimeofday)
		worldstarttime = world.time
		worldstarttimeofday = world.timeofday
	statpanel("Status")
	stat("Status",null)
	stat(null, "Server time of day : [time2text(world.timeofday)]")
	stat(null, "Server CPU : %[world.cpu]")
	//stat(null, "Health : %[round(health)]")
	//stat(null, "Shield : %[round(shield)]")
	if(veh)
		if(veh.Kart)
			stat("Racing status",null)
			stat(null, "Lap : [veh.lap]")
			stat(null, "Lap completed : %[(veh.checkpoint/8)*100]")
			stat("Other people",null)
			for(var/obj/machinery/vehicle/k in karts)
				if(k.Kart == 1)
					stat(null, "[k.name] - [k.lap] - %[(k.checkpoint/8)*100]")

	statpanel("Debugging information") //Debug.
	var/tickdrift = (world.timeofday - worldstarttimeofday) - (world.time - worldstarttime)  / world.tick_lag
	stat("MAIN",null)
	stat(null, "Particles : [PARTICLE_LIST.len]")
	stat(null, "3D Position : [x], [round(heightZ)], [y], [z]")
	stat(null, "Health : %[health]")
	stat(null, "Server CPU : %[world.cpu] - [world.tick_usage]")
	stat(null, "Server Time : [time2text(world.realtime)]")
	stat(null, "Tick Drift : [tickdrift]")
	stat(null, "World port : [world.port]")
	if(client)
		stat(null, "Server FPS : [world.fps] FPS - [world.tick_lag/10] SECS")
		stat(null, "Client FPS : [client.fps] FPS - [client.tick_lag/10] SECS (sync if 0)")
		stat(null, "Next move : [max((client.move_delay-world.time)*10,0)]")
	if(master_controller)
		stat("MASTER",null)
		stat(null, "Master timer : [master_controller.wait]")
		stat(null, "Actions done : [actions_per_tick]")
		stat(null, "Processed : [master_Processed]")
		stat(null, "Max actions : [max_actions]")
		stat("ATMOS",null)
		stat(null, "Processed : [atmos_processed]")
		stat(null, "Actions done : [actions_per_tick_atmos]")
		stat(null, "Max actions : [max_actions_atmos]")
