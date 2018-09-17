/datum/game_mode/battle_royale
	name = "Dab Station 13 Battle Royale"
	config_tag = "fortnite"
	events_enabled = 0
	do_kick = 1

/datum/game_mode/battle_royaleg/pre_setup()
	..()
	return 1
/datum/game_mode/battle_royale/announce()
	world << "<B>The current game mode is - Dab Battle Royale 13</B>"
	world << "<B>Get ready to fight!</B>"


/datum/game_mode/battle_royale/ending()
	world << sound(null)


/datum/game_mode/battle_royale/check_finished()
	var/mob/lastplr = null
	for(var/mob/i in Mobs)
		if(!istype(i,/mob/dead))
			if(i.health > 0)
				lastplr = i

	if(plrs <= 1)
		if(lastplr)
			world.log << "[lastplr.name] won!"
			lastplr << "<b><font size=6><font color='#00FFFF'>First place, victory royale!"
		return 1
	return 0



/mob/living/carbon/human/proc/Spawn_Fortain(rank, joined_late)
	src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

	src.equip_if_possible(new /obj/item/clothing/under/lightblue(src), slot_w_uniform)
	src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)

	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)
	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)
	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)
	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)
	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)
	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_in_backpack)

	src.equip_if_possible(new /obj/item/weapon/grenade/explosiongrenade(src), slot_l_hand)
	//src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_r_hand)

	src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)

	var/obj/item/weapon/tank/air/AAA = new(src)
	src.equip_if_possible(AAA, slot_l_store)
	src.internal = AAA //Toggle internals.

	src << "<b>\green You have automatically enabled your internals and are now landing. Move!"
	spawnId(rank)
	src << 'storm.ogg'
	src.job = rank
	src.mind.assigned_role = rank

	//if (!joined_late && rank != "Tourist")

	src.loc = locate(275,86,1)
	spawn()
		for(var/i in 1 to 1000) //999 frames, like 9 seconds
			sleep(world.tick_lag)
			src.heightZ = 416


	return