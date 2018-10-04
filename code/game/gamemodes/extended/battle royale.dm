/datum/game_mode/battle_royale
	name = "Dabber Station 13 Battle Royale"
	config_tag = "fortnite"
	events_enabled = 0
	do_kick = 1

/datum/game_mode/battle_royale/pre_setup()
	..()
	return 1
/datum/game_mode/battle_royale/announce()
	world << "<B>The current game mode is - Dab13 Battle Royale</B>"
	world << "<B>Get ready to fight!</B>"
	//244,202
	new /turf/unsimulated/wall(locate(249,295,1))
	sandbox = -1
	BATTLE_ROYALE_PLANE = new(locate(242,203,1))
	STORM = new(locate(202+49,202+49,1))
	var/list/objects = list(
	/obj/item/weapon/gun/pistol,
	/obj/item/weapon/gun/machine_gun,
	/obj/item/weapon/storage/backpack,
	/obj/item/weapon/grenade/explosiongrenade,
	/obj/item/weapon/classic_baton,
	/obj/item/clothing/suit/armor/vest,
	/obj/item/clothing/suit/armor/swat,
	/obj/item/weapon/reagent_containers/food/drinks/cola,
	/obj/item/weapon/reagent_containers/food/drinks/slurp_juice
	)
	for(var/obj/loot_spawner/G in world)
		for(var/i in 1 to rand(2,3))
			var/A = pick(objects)
			var/location = locate(G.x+rand(-1,1),G.y+rand(-1,1),G.z)
			if(location:density == 0)
				new A(location)
			else
				new A(G.loc)


/datum/game_mode/battle_royale/ending()
	..()

/datum/game_mode/battle_royale/check_finished()
	if(dropped > 0)
		var/client/lastplr = null
		for(var/client/i in clients)
			if(!istype(i.mob,/mob/dead))
				if(i.mob.health > 0)
					lastplr = i
		if(plrs <= 1)
			if(lastplr)
				world << "<b><font size=6><font color='#00FFFF'>[lastplr.key] won!"
				sleep(10)
				world << 'victory.ogg'
				world.fps = 6 //slow mo effect
				sleep(22)
				world.fps = 60
				return 1
	return 0

var/dropped = 0
/obj/loot_spawner
	//random loot spawner
	density = 0
	anchored = 1
	icon = 'screen1.dmi'
	icon_state = "x2"
	mouse_opacity = 0

/area/var/storm = 0
/area/forest/storm = 1

turf
	proc
		init_storm()
			if(!shading)
				shading = new(locate(x,y,z))
				shading.icon_state = "storm" //easy to handle

var/obj/storm_overlay/STORM = null
obj/storm_overlay
	anchored = 1
	plane = SHADING_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = RESET_COLOR
	icon = 'bigcircle.dmi'
	icon_state = "circle"
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32
	ex_act()
		return
	layer = LIGHT_LAYER + 1

var/obj/plane_thing/BATTLE_ROYALE_PLANE = null
/obj/plane_thing
	//for battle royale
	icon = 'battle_royale_plane.dmi'
	plane = BELOW_SHADING //ontop everything
	var/forced_drop = 0
	var/obj/shadow/s = null
	pixel_x = -40+16
	pixel_z = 200
	New()
		..()
		special_processing += src
		s = new()
		s.icon = icon
		s.icon_state = icon_state
	Del()
		del s
		special_processing -= src
		..()
	special_process()
		if(y > 293)
			forced_drop = 1
		glide_size = 32 / 2.5 * tick_lag_original
		if(frm_counter % 15 == 1)
			y += 1
		s.pixel_x = pixel_x
		s.glide_size = glide_size
		s.loc = loc
		if(z == 0)
			del src
/mob/living/carbon/human/proc/Spawn_Fortain(rank, joined_late)
	src.equip_if_possible(new /obj/item/clothing/under/lightblue(src), slot_w_uniform)
	src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)

	src << 'storm.ogg'

	src.loc = locate(202,202,1)
	if (client && BATTLE_ROYALE_PLANE)
		src << "Press space to jump into the map! You will be forced off automatically if you don't."
		//var/yG = 203
		spawn()
			while(BATTLE_ROYALE_PLANE.forced_drop == 0 && client && client.j == 0)
				client.eye = BATTLE_ROYALE_PLANE
				sleep(world.tick_lag)
			if(client)
				client.eye = src
			loc = BATTLE_ROYALE_PLANE.loc
			heightZ = 200
			ySpeed = 0
			world << sound("sound/busdrop[rand(1,3)].ogg")
			spawn(20)
				dropped += 1
	return