/*
Height Processing, Jumping, And all that other fancy stuff.
*/

var/HeightMobs = list() //Which mobs need to be processed?
var/Mobs = list()
//#define GRAVDEBUG  //Only define this if you want spammy shit.
#define FONTCOLOR "<font color='green'>Height Debug : "

datum/controller/game_controller
	proc
		do_gravity_loop() //Gravity loop, Call in a loop that runs at world.fps.
			for(var/mob/M in Mobs)
				M.ParallaxMove()
				if(!(M in HeightMobs))
					if(!istype(M,/mob/new_player))
						HeightMobs += M
				else
					M.ProcessDirection() //Process buckled (no delays)
					M.ProcessHeight() //Process their Y Speed and height.
					if(M)
						if(M.client && istype(M,/mob/living/carbon/human))
							M:handle_regular_status_updates()
							M:handle_regular_hud_updates()
						if(M.ANIMATION_RUNNING)
							M.dir = 2
							if(M.danc)
								M.danc.Update_Y()
		mobs_process()
			for(var/mob/M in Mobs)
				CHECK_TICK()
				M.Life()
mob
	New()
		..()
		Mobs += src
obj
	shadow
		anchored = 1
		layer = 3.999
		mouse_opacity = 0
		alpha = 150
		name = "shadow object"
		icon = 'extra images/boring shit.dmi'
		icon_state = "shadow"
		ex_act()
			return
		appearance_flags = PIXEL_SCALE | LONG_GLIDE

turf
	var/TurfGravity = 96/256 //Obvious variable names
	var/TurfStepSound = list('footstep1.ogg','footstep2.ogg','footstep3.ogg','footstep4.ogg')
	var/TurfHeight = 0
	mouse_opacity = 2 //Fixes RCD shit
	space
		TurfStepSound = null
		TurfGravity = 24/256
		TurfHeight = -416
	unsimulated
		space2
			alpha = 0
			TurfHeight = -416
	simulated
		floor
			level = 2
			New()
				..()
				if(TurfHeight >= 32)
					plane = MOB_PLANE_ALT
					Get_Layer_Y(-1)
/turf/simulated/floor/plating/water
	level = 1
	TurfHeight = 0

	ex_act()
		return
mob
	var/heightZ = 0 //Height.
	var/ySpeed = 0 //Y speed
	var/onFloor = 0 //Am I on floor?
	var/heightSize = 28
	var/pixel_y_2 = 0
	real_pixel_x = 11
	pixel_collision_size_x = 8
	pixel_collision_size_y = 29
	var/obj/shadow/MyShadow = null //Shadow. This is handled in master controller.

	#if defined(GRAVDEBUG)
	var/MessageCurr = ""
	#endif

	Del()

		#if defined(GRAVDEBUG)
		world << "[FONTCOLOR]removing [src] from heightmobs"
		#endif
		ghostize(1)
		if(danc)
			del danc
		if(src in HeightMobs)
			HeightMobs -= src
		if(src in Mobs)
			Mobs -= src
		del MyShadow
		MyShadow = null //Make sure to delete shadow.
		..()

	#if defined(GRAVDEBUG)
	verb/ChangeYSpeed(ass as num)
		ySpeed = ass
	#endif

	proc/Jump()
		if(canmove == 1 && lying == 0 && !src.restrained() && !ANIMATION_RUNNING ) //If on floor/space and not restrained...
			if(onFloor == 1)
				ySpeed = 1320/256
				view(15,src) << 'jump.ogg'
			else
				flyPack()
	proc/flyPack()
		if(istype(src.back, /obj/item/weapon/tank/jetpack))
			var/j_pack = 0
			if (istype(src.back, /obj/item/weapon/tank/jetpack))
				var/obj/item/weapon/tank/jetpack/J = src.back
				j_pack = J.allow_thrust(0.01, src)
			if(j_pack)
				ySpeed = ySpeed + (27/256)

	proc/ProcessDirection()
		if(buckled)
			buckled.glide_size = glide_size
			dir = buckled.dir
			pixel_w = buckled.pixel_x
			if(dir & EAST)
				pixel_w = buckled.pixel_x+(buckled.pixel_x_off*-1) //((dir & EAST) ? -1 : 1)
			if(dir & WEST)
				pixel_w = buckled.pixel_x+(buckled.pixel_x_off*1)
			buckled.layer = MOB_LAYER-0.1+((buckled.dir == SOUTH)*0.2)
			pixel_y_2 = buckled.pixel_y+buckled.pixel_y_off

			loc = buckled.loc
		else
			pixel_w = 0
			pixel_y_2 = 0

	proc/ProcessHeight()
		if(!MyShadow)
			MyShadow = new
		Get_Layer_Y((src.resting || src.lying/-10)) //People laying down are below you.

		onFloor = 0
		var/turf/T = locate(x,y,z) //Gets turf player is stepping on.
		if(!loc || !istype(T,/turf) || veh)
			MyShadow.alpha = 0
			return //We cannot process height, either player is on a vehicle, or player is deleted (null) or what we are stepping on doesn't even have a turf.

		if(client)
			if(client.j)
				ySpeed = ySpeed - (T.TurfGravity/2) //Adds gravity.
			else
				ySpeed = ySpeed - T.TurfGravity //Adds gravity.
		else
			ySpeed = ySpeed - T.TurfGravity //Adds gravity.

		if(heightZ > 416) heightZ = 416

		heightZ = heightZ + ySpeed //Changes height by speed.

		for(var/mob/i in loc)
			if(i != src)
				if(i.density)
					if(heightZ > i.heightZ-heightSize && heightZ < i.heightZ+(round(i.heightSize/2))) //if below
						heightZ = i.heightZ-heightSize
						ySpeed = 0
					if(heightZ < i.heightZ+i.heightSize && heightZ > i.heightZ+(round(i.heightSize/2))-1) //only stack if ontop or some bullshit
						onFloor = 1
						ySpeed = 0
						heightZ = i.heightZ+i.heightSize
						if(istype(src,/mob/living/carbon/human) && istype(src:shoes,/obj/item/clothing/shoes/brown/goomba_stomp))
							i.specialloss += 15
							view(10,src) << 'hitJump.ogg'
							ySpeed = 3
		var/obj/lattice/LAT = locate(/obj/lattice) in T
		if(LAT)
			if(ySpeed < 0)
				if(heightZ < 0 && heightZ > -8)
					if(ySpeed < -3)
						playsound(LAT, 'bang.ogg', 100, 0, 5, 0)
						del LAT
					else
						onFloor = 1
						ySpeed = 0
						heightZ = 0
		if(heightZ < T.TurfHeight) //Don't make players go under the floor. todo fix this bullshit because turfs aren't being picked up correctly
			heightZ = T.TurfHeight
			onFloor = 1
			ySpeed = 0

		if(heightZ > T.TurfHeight)
			plane = MOB_PLANE_ALT
		else
			if(heightZ > 0)
				plane = MOB_PLANE_ALT
			else
				plane = MOB_PLANE //this is to fix the "lol airlocks are above me even tho im jumping"
		if(heightZ < 0)
			plane = FLOOR_PLANE
			layer = 1.9
		if(heightZ < -415 && !istype(src,/mob/dead))
			src << "<b><font color='red'>You were never seen again.."
			death(2)
			del src
		else
			if(heightZ < 0 && istype(src,/mob/dead))
				heightZ = 0

		if(MyShadow) //Handle shadow transparency.
			MyShadow.alpha = max(220-((heightZ-T.TurfHeight)*3),100)
			MyShadow.pixel_z = T.TurfHeight+pixel_y_2
			MyShadow.layer = layer-0.05
			MyShadow.pixel_x = pixel_x+pixel_w
			MyShadow.loc = loc

		pixel_z = round(heightZ)+round(pixel_y_2) //Set pixel_z.
		if(buckled)
			buckled.pixel_z = round(heightZ)
		if(c2)
			if(T.TurfHeight < 0)
				c2.icon_state = "heightNOFL"
			else
				c2.icon_state = "height"
		if(c1)
			c1.screen_loc = "WEST+3, NORTH:[max(1,min(round((heightZ/416)*32)+1,30))]"