/*
TO-DO overly optimize
*/

mob
	Move(NewLoc,Dir,step_x,step_y)
		if(ANIMATION_RUNNING)
			return
		var/turf/OldLoc = src.loc

		..()
		//world << "hi this just got called"
		var/turf/TA = NewLoc //We need to check if we can get here actually.
		var/canStandHere = 1
		for(var/atom/i in TA)
			if(istype(i,/mob))
				if(i != src)
					//world << "heightZ >= i.heightZ = <font color='green'>[heightZ >= i.heightZ]</font> - heightZ <= i.heightZ+heightSize = <font color='green'>[heightZ <= i.heightZ+heightSize]</font>"
					if(heightZ+heightSize > i:heightZ && heightZ < i:heightZ+i:heightSize)
						//world << "<font color='red'>no you idiot dont stand on the [i]"
						canStandHere = 0
			else
				if(i.density)
					canStandHere = 0
		if(TA.density)
			canStandHere = 0
		if(heightZ <= -8-heightSize)
			canStandHere = 1
		if(heightZ < TA.TurfHeight && heightZ > -8-heightSize)
			loc = OldLoc
		else
			if(canStandHere) //No dont go through... Dumb...
				loc = NewLoc
		for(var/mob/i in OldLoc.contents)
			if(i != src && i.heightZ == heightZ+heightSize)
				i.glide_size = glide_size
				i.Move(NewLoc,Dir,step_x,step_y)
		if(MyShadow)
			MyShadow.dir = dir
			MyShadow.loc = locate(x,y,z)

		if(loc == NewLoc)
			if(onFloor == 1) //we only make footsteps on ground.
				var/turf/T = locate(x,y,z)

				if(T && T.TurfStepSound != null)
					if(heightZ >= round(T.water_height))
						playsound(src, pick(T.TurfStepSound), 100, 0, 8, 0)
					else
						if(heightZ+heightSize >= round(T.water_height))
							playsound(src, pick('footstepw1.ogg','footstepw2.ogg','footstepw3.ogg'),100,0,10,0)

/obj/screen_alt/circle_part
	icon = '732x732hud.dmi'
	icon_state = "black"
	plane = HUD_PLANE_CIRCLE
	screen_loc = "CENTER+1:-370,CENTER+1:-370"
	appearance_flags = PIXEL_SCALE | TILE_BOUND
	mouse_opacity = 0
	var/offs_x = 0
	var/offs_y = 0

/client
	//animate_movement = 2

	var/s = 0
	var/n = 0
	var/e = 0
	var/w = 0
	var/j = 0
	var/spri = 0

	var/circle_size = 0
	var/target_size = 0
	var/list/circle_huds = null
	var/mousedown = 0
	proc/Generate_Circles()
		circle_huds = list()
		for(var/x in -1 to 1)
			for(var/y in -1 to 1)
				var/obj/screen_alt/circle_part/P = new()
				P.offs_x = x
				P.offs_y = y
				if(x == 0 && y == 0)
					P.icon_state = "circle"
				circle_huds += P
	proc/Edit_Circle()
		for(var/i in circle_huds)
			var/matrix/M = matrix()
			if(i:icon_state != "circle")
				M.Translate((circle_size*i:offs_x)+(i:offs_x*368),(circle_size*i:offs_y)+(i:offs_y*368))
			else
				M.Scale(circle_size/368)
			M.Translate(-16,-16)
			i:transform = M
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
			if("shift")
				spri = 1
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
			if("shift")
				spri = 0
	DblClick(atom/object,location,control,params)
		..()
		if(object && spri)
			object.examineproc(mob)
	MouseDown(atom/object,location,control,params)
		..()
		mousedown = 1
		var/obj/item/weapon/gun/G = null
		if (!( mob.hand ))
			G = mob.r_hand
		else
			G = mob.l_hand
		if(istype(G,/obj/item/weapon/gun))
			if(!(object in screen))
				if(!G.automatic)
					if(mouse_position && eye && mousedown)
						var/mos_x = mouse_position.WorldX()
						var/mos_y = mouse_position.WorldY()
						G.fire(mob,mos_x,mos_y)
	MouseUp()
		..()
		mousedown = 0
	proc/GetDirection()
		set waitfor = FALSE
		var/obj/item/weapon/gun/G = null
		if (!( mob.hand ))
			G = mob.r_hand
		else
			G = mob.l_hand
		var/can_mo = 1
		if(istype(G,/obj/item/weapon/gun))
			if(mousedown)
				can_mo = 0
		if(mob)
			if(spri)
				mob.m_intent = "run"
				if(mob.hud_used)
					if(mob.hud_used.move_intent)
						mob.hud_used.move_intent.icon_state = "running"
			else
				mob.m_intent = "walk"
				if(mob.hud_used)
					if(mob.hud_used.move_intent)
						mob.hud_used.move_intent.icon_state = "walking"
		var/dirAA = (s*SOUTH)+(n*NORTH)+(e*EAST)+(w*WEST)
		if(dirAA != 0 && can_mo)
			Move(get_step(mob,dirAA),dirAA)
		if(j)
			mob.Jump()
		if(mouse_position && eye && mousedown)
			var/mos_x = mouse_position.WorldX()
			var/mos_y = mouse_position.WorldY()
			mob.dir = get_dir(mob.loc,locate((mos_x/32)+1,(mos_y/32)+1,mob.z))
			if(mob.MyShadow)
				mob.MyShadow.dir = mob.dir
			if(istype(G,/obj/item/weapon/gun) && G.automatic)
				G.fire(mob,mos_x,mos_y)
		if (isobj(src.mob.loc) || ismob(src.mob.loc))
			var/atom/O = src.mob.loc
			if (src.mob.canmove)
				return O.relaymove(src.mob, dirAA)

/client/Move(n, direct)
	if (!( src.mob ))
		return
	if(src.mob.ANIMATION_RUNNING)
		return
	var/old_loc = mob.loc
	glide_size = mob.glide_size

	if(istype(src.mob, /mob/dead/observer))
		var/g = src.mob.Move(n,direct)
		if(mob)
			if(mob.MyShadow)
				mob.MyShadow.loc = mob.loc
		return g

	if (src.moving)
		return 0

	if (src.mob.stat == 2)
		return

	if (isobj(src.mob.loc) || ismob(src.mob.loc))
		return 0

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

	if(round(mob.current_angle_speed) != 0) //players whose tilted cannot move
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

			if (src.mob.drowsyness > 0)
				src.move_delay += 6

			switch(src.mob.m_intent)

				if("run")

					src.move_delay += 3

				if("walk")
					src.move_delay += 4

			src.move_delay += src.mob.movement_delay()
			if (src.mob.resting || src.mob.lying)
				return 0
			if (src.mob.restrained())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
						src << "\blue You're restrained! You can't move!"
						return 0

			src.moving = 1

			var/RLMove = max(tick_lag_original,(src.move_delay - world.time))
			mob.glide_size = (world.icon_size/RLMove)*tick_lag_original

			glide_size = mob.glide_size
			if(mob.MyShadow)
				mob.MyShadow.glide_size = mob.glide_size

			if(src.mob.confused)
				step(src.mob, pick(cardinal))
			else
				. = ..()
			var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in mob
			if (G)
				var/mob/M = G.affecting
				if(istype(M,/mob))
					M.other_mobs = 1
					spawn(0)
						M.glide_size = mob.glide_size
						step(M,get_dir(M,old_loc))
					spawn(1)
						M.other_mobs = null

			src.moving = null
	if(mob)
		if(mob.MyShadow)
			mob.MyShadow.loc = mob.loc
	return .

var/current_radio_song = null

client/proc/ProcessClient()
	set waitfor = FALSE
	shake *= -0.95
	if(shake < 0.5 && shake > -0.5)
		shake = 0
	pixel_y4 = shake
	pixel_y = round(pixel_y1 + pixel_y2 + pixel_y3 + pixel_y4 + pixel_y5)
	GetDirection()
	if(mob)
		if(istype(mob,/mob/living))
			create_health()
			if(mob.health <= 20)
				target_size = 64
			else
				target_size = 736
		if(mouse_position)
			if(!(mouse_position.MouseCatcher in screen))
				screen += mouse_position.MouseCatcher
		else
			mouse_position =  new(src)
		if(!inited_audio_files)
			var/A_S = 0
			for(var/sound/i in list(amb_sound,amb_sound_ext,amb_sound_area,radio_sound,amb_sound_water,amb_sound_vore))
				if(i.status != SOUND_UPDATE)
					i.status = SOUND_UPDATE
					i.channel = SOUND_CHANNEL_1+A_S
					i.repeat = 1
					A_S = A_S + 1
			inited_audio_files = 1
		var/turf/T = mob.loc
		if(T)
			var/area/A = T.loc
			if(istype(A,/area))
				if(A.name != "Space" && !A.song && A.ambi == 1 && !istype(T,/turf/space))
					inc_volume()
				else
					if(A.song)
						if(A.song != old_song)
							old_song = A.song
							src << sound(null,channel=SOUND_CHANNEL_1+2)
							amb_sound_area.file = A.song
					dec_volume(A.song != null)
		else
			var/area/A = T.loc
			if(istype(A,/area))
				if(A.song)
					if(A.song != old_song)
						old_song = A.song
						src << sound(null,channel=SOUND_CHANNEL_1+2)
						amb_sound_area.file = A.song
				dec_volume(A.song != null)
		if(ticker)
			if(istype(ticker.mode,/datum/game_mode/battle_royale))
				mob.ProcessBattleRoyale()
		if(mob.amm)
			var/obj/item/weapon/gun/G = null
			G = !( mob.hand ) ? mob.r_hand : mob.l_hand
			if(istype(G,/obj/item/weapon/gun))
				mob.amm.maptext = {"<div align="right">%[max(0,min(100,round(mob.air*4)))] AIR - [G.ammo]/[G.ammo_max] AMMO"}
			else
				mob.amm.maptext = {"<div align="right">%[max(0,min(100,round(mob.air*4)))] AIR"}
		if(mob.cpu_us)
			mob.cpu_us.maptext = {"<div align="left">%[world.cpu] - [clients.len]/[MAX_PLAYERS]
[world.contents.len] instances"}
		if(mob.timer_hud)
			if(nuke_enabled)
				mob.timer_hud.maptext = {"<div align="right">[round(nuke_timer/60)]:[(round(nuke_timer) % 60) < 10 ? "0[round(nuke_timer) % 60]" : round(nuke_timer) % 60]"}
			else
				if(STORM)
					mob.timer_hud.maptext = {"<div align="right">[(STORM.timer_left > 0) ? "[round(STORM.timer_left/60)]:[(round(STORM.timer_left) % 60) < 10 ? "0[round(STORM.timer_left) % 60]" : round(STORM.timer_left) % 60]" : "0:00"]"} //STORM.timer_left
				else
					mob.timer_hud.maptext = {"<div align="right">[time2text(world.realtime,"hh:mm:ss")]"}

		circle_size += max(-4,min(4,((target_size-circle_size))))

		if(circle_huds)
			if(!(circle_huds[1] in screen))
				screen += circle_huds
			Edit_Circle()
		else
			Generate_Circles()

		music_pitch += max(-0.0025,min(0.0025,((music_pitch_new-music_pitch)/100)))
		amb_sound.volume = vol
		amb_sound_ext.volume = vol_ext
		amb_sound_ext.frequency = music_pitch
		amb_sound_water.volume = istype(T,/turf) ? ((mob.heightZ > -8-mob.heightSize)*(mob.heightZ+mob.heightSize<round(T.water_height)))*100 : 0
		amb_sound.frequency = music_pitch

		vore_sound_handler()

		radio_sound.frequency = music_pitch
		if(amb_sound_area.file)
			amb_sound_area.frequency = music_pitch
			amb_sound_area.volume = vol_area*music_vol_mult
			src << amb_sound_area
		src << amb_sound
		src << amb_sound_ext
		src << amb_sound_water
		src << amb_sound_vore
		if(current_radio_song != old_radio_sound)
			old_radio_sound = current_radio_song
			src << sound(null,channel=SOUND_CHANNEL_1+3)
			radio_sound.file = current_radio_song
		if(radio_sound && istype(mob,/mob/living/carbon/human))
			if(istype(mob:ears,/obj/item/device/radio/headset) && radio_sound.file)
				radio_sound.volume = 100
			else
				radio_sound.volume = 0
		else
			radio_sound.volume = 0
		src << radio_sound


/client/proc/create_health()
	if(health.len == 0)
		var/obj/screen_num/numbG2 = new()
		numbG2.icon = 'screen1.dmi'
		numbG2.screen_loc = "EAST:-4,CENTER"
		numbG2.icon_state = "%"
		health += numbG2
		for(var/i in 1 to 3)
			var/obj/screen_num/numbG = new()
			numbG.icon = 'screen1.dmi'
			numbG.screen_loc = "EAST:[((i-1)*4)-4],CENTER"
			//screen += numbG
			health += numbG
	if(!(health in screen))
		screen += health
	var/plrText = "[round(max(0,(mob.health/mob.maxhealth)*100))]"
	if(length(plrText) == 2) //Can't be 50, must be something like _50
		plrText = " [plrText]"
	if(length(plrText) == 1)
		plrText = "  [plrText]"
	for(var/i in 1 to 3)
		var/obj/screen_num/numbG = health[i+1]
		if(numbG)
			numbG.icon_state = "healthnum[copytext(plrText,i,i+1)]" //Get every digit

client/proc/dec_volume(var/am_i)

	vol = vol - 5
	if(vol < 0)
		vol = 0
	if(am_i)
		vol_ext = vol_ext - 5
		vol_area = vol_area + 5
		if(vol_area > 100)
			vol_area = 100
		if(vol_ext < 0)
			vol_ext = 0
	else
		vol_area = vol_area - 5
		if(vol_area < 0)
			vol_area = 0
		vol_ext = vol_ext + 5
		if(vol_ext > 100)
			vol_ext = 100

client/proc/inc_volume()
	vol = vol + 5
	vol_area = vol_area - 5
	vol_ext = vol_ext - 5
	if(vol_area < 0)
		vol_area = 0
	if(vol_ext < 0)
		vol_ext = 0
	if(vol > 100)
		vol = 100
area
	var/ambi = 1

client
	control_freak = CONTROL_FREAK_ALL | CONTROL_FREAK_MACROS
	var/pixel_y1 = 0 //normal shit
	var/pixel_y2 = 0 //kart shit
	var/pixel_y3 = 0 //effects
	var/pixel_y4 = 0 //misc shit i think
	var/pixel_y5 = 0 //height system
	var/shake = 0
	var/music_vol_mult = 1
	var/inited_audio_files = 0

	var/list/health = list() //Health hud stuff
	var/sound/amb_sound = sound('music/interior.ogg')
	var/vol = 0 //Ambient sound vol
	var/sound/amb_sound_ext = sound('music/exterior.ogg')
	var/vol_ext = 0 //Ambient sound vol
	var/sound/amb_sound_area = sound('music/silence.ogg')
	var/sound/amb_sound_water = sound('music/water.ogg')
	var/old_song = 'music/silence.ogg'
	var/vol_area = 0 //Ambient sound vol
	var/sound/radio_sound = sound('music/silence.ogg')
	var/old_radio_sound = null
	var/music_pitch = 1
	var/music_pitch_new = 1
	verb
		Mute_Music()
			music_vol_mult = !music_vol_mult
			if(music_vol_mult)
				src << "<b>Music enabled."
			else
				src << "<b>Music disabled."
/obj/screen
	appearance_flags = PIXEL_SCALE | TILE_BOUND | NO_CLIENT_COLOR
/obj/screen_num
	plane = HUD_PLANE
	appearance_flags = PIXEL_SCALE | TILE_BOUND | NO_CLIENT_COLOR
/obj/screen_alt
	appearance_flags = PIXEL_SCALE | TILE_BOUND | NO_CLIENT_COLOR
	plane = HUD_PLANE
	ammo
		maptext_width = 128+32
		screen_loc = "EAST-8:-16,SOUTH:4"
		alpha = 170
	timer
		maptext_width = 128
		screen_loc = "EAST-7:-16,SOUTH:4"
		maptext_y = 16
		alpha = 170
	cpu_u
		screen_loc = "1:4,NORTH:-4"
		maptext_width = 128
		maptext_y = 4
		alpha = 100

/obj/screen_alt/heightCalc
	icon = 'screen1.dmi'
	icon_state = "plr"
	screen_loc = "EAST:-4, CENTER-1:-4"
	heightG
		icon_state = "height"
	water
		icon_state = "water_height"

/mob
	var/obj/screen_alt/heightCalc/c1 = null
	var/obj/screen_alt/heightCalc/heightG/c2 = null
	var/obj/screen_alt/heightCalc/water/c3 = null
	var/obj/screen_alt/ammo/amm = null
	var/obj/screen_alt/timer/timer_hud = null
	var/obj/screen_alt/cpu_u/cpu_us = null

/obj/hud/proc/extra_init_hud()
	if(!mymob.c1)
		mymob.c1 = new
	if(!mymob.c2)
		mymob.c2 = new
	if(!mymob.c3)
		mymob.c3 = new
	if(!mymob.amm)
		mymob.amm = new
	if(!mymob.timer_hud)
		mymob.timer_hud = new
	if(!mymob.cpu_us)
		mymob.cpu_us = new
	mymob.client.screen += mymob.c1
	mymob.client.screen += mymob.c3
	mymob.client.screen += mymob.c2
	mymob.client.screen += mymob.amm
	mymob.client.screen += mymob.timer_hud
	mymob.client.screen += mymob.cpu_us