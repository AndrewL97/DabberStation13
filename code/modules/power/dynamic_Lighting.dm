/*


Nooberlights

kinda sucks


*/


var/list/global_turfs_lig = list()

atom
	var
		lightl = 0
		sd_lumcount = 0
	proc
		sd_SetLuminosity(amount)
			//world << "<font color='yellow'>Received light call to [amount]"
			lightl = amount
		sd_SetOpacity(var/newOpacity)
			opacity = newOpacity
		sd_NewOpacity(var/newOpacity)
			opacity = newOpacity
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

	spawn(10)
		if(sd_lighting == 1)
			world.log << "Generating lighting for [src]"
			for(var/turf/ar in src)
				//world << "found some turfs LOL"
				global_turfs_lig += ar

	spawn(15)
		src.power_change()		// all machines set to current power level, also updates lighting icon
area
	var
		sd_lighting = 0

world
	New()
		..()
		spawn()
			sleep(50)
			new /datum/lightingcontroller

/datum/lightingcontroller
	New()
		..()
		//world << "Found luminosity thing"
		spawn()
			while(1)
				sleep(10)
				world << "Next luminosity loop [rand(1,999)]"
				LightingLoop()

	proc/LightingLoop()

		for(var/turf/i in global_turfs_lig)
			i.sd_lumcount = 0
		for(var/turf/i in global_turfs_lig)
			for(var/atom/e in obounds(i,0,0,32,32))
				//world << "<font color='green'>Located a lighting object : [e] with [e.lightl]"
				i.sd_lumcount = i.sd_lumcount + e.lightl
			for(var/turf/f in view(5,src))
				f.sd_lumcount = i.sd_lumcount - distanceT(i,f)

		for(var/turf/i in global_turfs_lig)
			var/turf/right = locate(x+1,y,z)
			var/turf/left = locate(x-1,y,z)
			var/turf/up = locate(x,y+1,z)
			var/turf/down = locate(x,y-1,z)


			i.setLightingOverlay(right.sd_lumcount,down.sd_lumcount,left.sd_lumcount,up.sd_lumcount,)

proc/distanceT(atom/A, atom/B)
	return abs(sqrt((B.x-A.x)**2 + (B.y-A.y)**2))

turf
	var/image/sd_darkimage = null
	proc
		setLightingOverlay(var/C1,var/C2,var/C3,var/C4)
			if(sd_darkimage in overlays)
				overlays -= sd_darkimage

			var/image/light = image('ss13_dark_alpha7.dmi',,"RGB",100)

			var/CTurf1 = max(255-(sd_lumcount*25),0)
			var/CTurf2 = max(255-(sd_lumcount*25),0)
			var/CTurf3 = max(255-(sd_lumcount*25),0)
			var/CTurf4 = max(255-(sd_lumcount*25),0)

			/*

			Light stuff

			RR 1
			RG 2
			RB 3
			RA 4
			GR 5
			GG 6
			GB 7
			GA 8
			BR 9
			BG 10
			BB 11
			BA 12
			AR 13
			AG 14
			AB 15
			AA 16
			CR 17
			CG 18
			CB 19
			CA 20

			light.color = list(
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 1
			)

			*/

			light.color = list(
				0, 0, 0, CTurf/255,
				0, 0, 0, CTurf/255,
				0, 0, 0, CTurf/255,
				0, 0, 0, CTurf/255,
				0, 0, 0, 0
			)
			sd_darkimage = light
			overlays += sd_darkimage
