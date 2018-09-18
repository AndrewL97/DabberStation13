mob
	Move(NewLoc,Dir,step_x,step_y)
		if(ANIMATION_RUNNING)
			return
		var/turf/OldLoc = src.loc

		..()
		//world << "hi this just got called"
		var/turf/TA = NewLoc //We need to check if we can get here actually.

		var/canStandHere = 1
		for(var/mob/i in TA.contents)
			if(i != src)
				//world << "heightZ >= i.heightZ = <font color='green'>[heightZ >= i.heightZ]</font> - heightZ <= i.heightZ+heightSize = <font color='green'>[heightZ <= i.heightZ+heightSize]</font>"
				if(heightZ+heightSize > i.heightZ && heightZ < i.heightZ+i.heightSize)
					//world << "<font color='red'>no you idiot dont stand on the [i]"
					canStandHere = 0
		for(var/atom/i in NewLoc)
			if(!istype(i,/mob))
				if(i.density)
					canStandHere = 0
		if(TA.density)
			canStandHere = 0
		if(heightZ < TA.TurfHeight)
			loc = OldLoc
		else
			if(canStandHere) //No dont go through... Dumb...
				loc = NewLoc
		for(var/mob/i in OldLoc.contents)
			if(i != src && i.heightZ == heightZ+heightSize)
				i.glide_size = glide_size
				i.Move(NewLoc,Dir,step_x,step_y)
		if(MyShadow)
			MyShadow.loc = locate(x,y,z)

		if(loc == NewLoc)
			if(onFloor == 1) //we only make footsteps on ground.
				var/turf/T = locate(x,y,z)

				if(T && T.TurfStepSound != null)
					var/sound/S = sound(pick(T.TurfStepSound))
					S.frequency = rand(99,101)/100
					view() << S
/client
	//animate_movement = 2
	var/s = 0
	var/n = 0
	var/e = 0
	var/w = 0
	var/j = 0
	//fps = 60
	var/mousedown
	verb/KeyDownM(a as text)
		set instant = 1
		set hidden = 1
		switch(a)
			if("east")
				e = 1
			if("west")
				w = 1
			if("south")
				s = 1
			if("north")
				n = 1
			if("jump")
				j = 1
	verb/KeyUpM(a as text)
		set instant = 1
		set hidden = 1
		switch(a)
			if("east")
				e = 0
			if("west")
				w = 0
			if("south")
				s = 0
			if("north")
				n = 0
			if("jump")
				j = 0
	MouseDown()
		..()
		mousedown = 1
	MouseUp()
		..()
		mousedown = 0
	proc/GetDirection()
		var/obj/item/weapon/gun/G = null
		if (!( mob.hand ))
			G = mob.r_hand
		else
			G = mob.l_hand
		var/can_mo = 1
		if(istype(G,/obj/item/weapon/gun))
			if(mousedown)
				can_mo = 0
		var/dirAA = (s*SOUTH)+(n*NORTH)+(e*EAST)+(w*WEST)
		if(dirAA != 0 && can_mo)
			Move(get_step(mob,dirAA),dirAA)
		if(j)
			mob.Jump()
		if(mouse_position && eye && mousedown)
			var/mos_x = mouse_position.WorldX()
			var/mos_y = mouse_position.WorldY()
			mob.dir = get_dir(mob.loc,locate((mos_x/32)+1,(mos_y/32)+1,mob.z))

			if(istype(G,/obj/item/weapon/gun))
				G.fire(locate((mos_x/32)+1,(mos_y/32)+1,mob.z),mob,(mos_x - 16) % 32,(mos_y - 16) % 32)
	Stat()
		..()
		if(mob)
			var/obj/item/weapon/gun/G = null
			if (!( mob.hand ))
				G = mob.r_hand
			else
				G = mob.l_hand
			if(istype(G,/obj/item/weapon/gun))
				stat("Gun ammo :","[G.ammo]/[G.ammo_max]")
/client/Move(n, direct)
	if (!( src.mob ))
		return
	if(src.mob.ANIMATION_RUNNING)
		return
	glide_size = mob.glide_size

	if(istype(src.mob, /mob/dead/observer))
		var/g = src.mob.Move(n,direct)
		if(mob)
			if(mob.MyShadow)
				mob.MyShadow.loc = mob.loc
		return g

	if (src.moving)
		return 0

	if (isobj(src.mob.loc) || ismob(src.mob.loc))
		var/atom/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, direct)

	if (src.mob.stat == 2)
		return

	if(mob)
		if(mob.buckled)
			mob.glide_size = mob.buckled.glide_size
			glide_size = mob.glide_size
			if(mob.MyShadow)
				mob.MyShadow.glide_size = mob.glide_size
			var/boy = mob.buckled.relaymove(mob, direct)
			if(mob.MyShadow)
				mob.MyShadow.loc = mob.loc
			return boy

	if (world.time < src.move_delay)
		return

	if(istype(src.mob, /mob/living/silicon/ai))
		return AIMove(n,direct,src.mob)

	if (src.mob.monkeyizing)
		return

	var/is_monkey = istype(src.mob, /mob/living/carbon/monkey)
	if (locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(src.mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.l_hand
			grabbing += G.affecting
		if (istype(src.mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/weapon/grab/G in src.mob.grabbed_by)
			if (G.state == 1)
				if (!( grabbing.Find(G.assailant) ))
					del(G)
			else
				if (G.state == 2)
					src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						mob.visible_message("\red [mob] has broken free of [G.assailant]'s grip!")
						del(G)
					else
						return
				else
					if (G.state == 3)
						src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							mob.visible_message("\red [mob] has broken free of [G.assailant]'s headlock!")
							del(G)
						else
							return

	if (src.mob.canmove)


		var/j_pack = 0
		if ((istype(src.mob.loc, /turf/space)))
			if (!( src.mob.restrained() ))
				if (!( (locate(/obj/grille) in oview(1, src.mob)) || (locate(/turf/simulated) in oview(1, src.mob)) || (locate(/obj/lattice) in oview(1, src.mob)) ))
					if (istype(src.mob.back, /obj/item/weapon/tank/jetpack))
						var/obj/item/weapon/tank/jetpack/J = src.mob.back
						j_pack = J.allow_thrust(0.01, src.mob)
						if(j_pack)
							src.mob.inertia_dir = 0
						if (!( j_pack ))
							return 0
					else
						return 0
			else
				return 0



		if (isturf(src.mob.loc))
			src.move_delay = world.time

			if ((j_pack && j_pack < 1))
				src.move_delay += 5

			switch(src.mob.m_intent)

				if("run")
					if (src.mob.drowsyness > 0)
						src.move_delay += 6

					src.move_delay += 2

				if("walk")
					src.move_delay += 3




			src.move_delay += src.mob.movement_delay()

			if (src.mob.restrained())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
						src << "\blue You're restrained! You can't move!" //gay
						return 0

			src.moving = 1

			var/RLMove = src.move_delay - world.time
			mob.glide_size = (world.icon_size/RLMove)*world.tick_lag
			//TILE_HEIGHT / move_delay * TICK_LAG
			glide_size = mob.glide_size
			if(mob.MyShadow)
				mob.MyShadow.glide_size = mob.glide_size

			if (locate(/obj/item/weapon/grab, src.mob))
				src.move_delay = max(src.move_delay, world.time + 7)

				var/list/L = src.mob.ret_grab()
				if (istype(L, /list))
					if (L.len == 2)
						L -= src.mob
						var/mob/M = L[1]
						if ((get_dist(src.mob, M) <= 1 || M.loc == src.mob.loc))
							var/turf/T = src.mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(src.mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(src.mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
					else
						for(var/mob/M in L)
							M.other_mobs = 1
							if (src.mob != M)
								M.animate_movement = 2
						for(var/mob/M in L)
							spawn( 0 )
								step(M, direct)
								return
							spawn( 1 )
								M.other_mobs = null
								M.animate_movement = 2
								return

			else
				if(src.mob.confused)
					step(src.mob, pick(cardinal))
				else
					. = ..()
			src.moving = null
	if(mob)
		if(mob.MyShadow)
			mob.MyShadow.loc = mob.loc
	return .