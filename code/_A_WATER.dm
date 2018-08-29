turf
	var/obj/water_overlay/gW1
	var/obj/water_overlay/gW2
	var/water_height = 0
	var/below_water_height = 0
	var/above_water_height = 0
	var/below_turf_height = 0
	var/fully_cover = 0

	proc/Render_Water_Icon()
		if(!gW1)
			gW1 = new(locate(x,y,z))
			gW1.layer = MOB_LAYER + 1
			gW1.plane = MOB_PLANE_ALT
		if(!gW2)
			gW2 = new(locate(x,y,z))
			gW2.layer = TURF_LAYER+0.5
		water_height = max(0,min(32,water_height))
		var/turf/below = locate(x,y-1,z)
		var/turf/above = locate(x,y+1,z)
		if(below)
			below_turf_height = below.TurfHeight
			below_water_height = below.water_height
		else
			below_turf_height = 0
			below_water_height = 0
		if(above)
			above_water_height = above.water_height
		else
			above_water_height = 0

		if(gW1.I)
			del gW1.I
		if(gW2.I)
			del gW2.I

		if(round(water_height) < 1)
			return
		gW1.I = icon('water sprites.dmi',"template",SOUTH)
		gW2.I = icon('water sprites.dmi',"template",SOUTH)
		if(round(water_height) != 1)
			if(!(fully_cover == 1 && water_height <= TurfHeight))
				gW1.I.DrawBox((round(below_water_height) > 0 || below_turf_height > TurfHeight) ? rgb(35,137,218) : rgb(15,94,156),1,1,32,round(water_height)-1)
		if(water_height >= TurfHeight)
			gW2.I.DrawBox(rgb(35,137,218),1,round(water_height),32,round(water_height)+(32)-round(above_water_height))
		gW1.icon = gW1.I
		gW2.icon = gW2.I


		gW1.I = icon('water sprites.dmi',"template",SOUTH)
		gW2.I = icon('water sprites.dmi',"template",SOUTH)

	Del()
		if(gW1)
			del gW1
		if(gW2)
			del gW2
		..()

obj
	water_overlay
		anchored = 1
		mouse_opacity = 0
		var/icon/I = null
		alpha = 150