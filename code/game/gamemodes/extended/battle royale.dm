/datum/game_mode/battle_royale
	name = "Dabber Station 13 Battle Royale"
	config_tag = "fortnite"
	events_enabled = 0
	do_kick = 1

/datum/game_mode/battle_royaleg/pre_setup()
	..()
	return 1
/datum/game_mode/battle_royale/announce()
	world << "<B>The current game mode is - Dab13 Battle Royale</B>"
	world << "<B>Get ready to fight!</B>"
	new /turf/unsimulated/wall(locate(249,295,1))
	sandbox = -1
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
	world << sound(null)


/datum/game_mode/battle_royale/check_finished()
	var/client/lastplr = null
	for(var/client/i in clients)
		if(!istype(i.mob,/mob/dead))
			if(i.mob.health > 0)
				lastplr = i
	if(plrs <= 0)
		if(lastplr)
			world << "<b><font size=6><font color='#00FFFF'>[lastplr.key] won!"
			sleep(10)
			world << 'victory.ogg'
			world.fps = 15 //slow mo effect
			sleep(22)
			world.fps = 60
			return 1
	return 0


/obj/loot_spawner
	//random loot spawner
	density = 0
	anchored = 1
	icon = 'screen1.dmi'
	icon_state = "x2"
	mouse_opacity = 0
	New()
		..()
		alpha = 0
/mob/living/carbon/human/proc/Spawn_Fortain(rank, joined_late)
	src.equip_if_possible(new /obj/item/clothing/under/lightblue(src), slot_w_uniform)
	src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)

	src << 'storm.ogg'

	src.loc = locate(202,202,1)
	if (client)
		src << "Press space to jump into the map! You will be forced off automatically if you don't."
		var/yG = 203
		spawn()
			while(yG < 292 && client && client.j == 0)
				if(frm_counter % 15 == 1)
					yG += 1
				heightZ = 99999
				ySpeed = 0
				glide_size = 32 / 2.5 * tick_lag_original
				loc = locate(242,yG,1)
				sleep(world.tick_lag)
			loc = locate(242,yG,1)
			heightZ = 2000
			ySpeed = 0
			world << sound("sound/busdrop[rand(1,3)].ogg")
	return