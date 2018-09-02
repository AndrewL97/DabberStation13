area
	var
		sd_lighting = 0
		forced_lighting = 1

atom
	var
		sd_lumcount = 0
	Del()
		if(light)
			del light
		..()
	proc
		sd_SetLuminosity(var/amount)
			if(lighting_inited == 0)
				return
			//world << "<font color='yellow'>Received light call to [amount] (FROM [src])"
			if(!light)
				//world << "<font color='yellow'>Creating new light."
				light = new(src, round(amount),0.5)
			else
				light.radius(round(amount))
				light.intensity(0.5)

		sd_SetOpacity(var/newOpacity)
			opacity = newOpacity
		sd_NewOpacity(var/newOpacity)
			opacity = newOpacity


/area/racing
	icon = 'racing.dmi'
	icon_state = "area"
	forced_lighting = 0
	CAN_GRIFE = 0

/area/New()

	src.icon = 'alert.dmi'
	spawn(1)
	//world.log << "New: [src] [tag]"

		master = src
		related = list(src)

		src.icon = 'alert.dmi'
		src.layer = 10

		if(name == "Space")			// override defaults for space
			requires_power = 0

		if(!requires_power)
			power_light = 1
			power_equip = 1
			power_environ = 1
			luminosity = 1
			if(indestructible_by_explosions == 1)
				sd_lighting = 1
			else
				sd_lighting = 0			// *DAL*
		else
			sd_lighting = 1
			luminosity = 1
			//sd_SetLuminosity(0)		// *DAL*


	/*spawn(5)
		for(var/turf/T in src)		// count the number of turfs (for lighting calc)
			if(no_air)
				T.oxygen = 0		// remove air if so specified for this area
				T.n2 = 0
				T.res_vars()

	*/

	spawn(15)
		src.power_change()		// all machines set to current power level, also updates lighting icon
