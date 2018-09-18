var/Current_Spawned_Rank = 0
var/current_place = 1
var/race_started = 0
var/KartPlayers = 0
var/list/karts = list()
#define MAXIMUM_LAPS 4



/client
	var/CurrentAngle = 0

/client/proc/Process_Kart_Racing()
	if(mob.plane_master_turf)
		if(mob.can_exit_pod == 0)
			if(mob.plane_master_turf)
				var/matrix/M = matrix()
				M.Scale(1)
				M.Turn(CurrentAngle)
				mob.plane_master_turf.transform = M
		else
			var/matrix/M = matrix()
			mob.plane_master_turf.transform = M

/mob/living/carbon/human/proc/Spawn_Kart(rank, joined_late)
	src << 'race.wav'
	src.can_exit_pod = 0
	src.equip_if_possible(new /obj/item/clothing/under/color/grey(src), slot_w_uniform)
	src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
	src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)

	var/obj/item/weapon/tank/air/AAA = new(src)
	src.equip_if_possible(AAA, slot_l_store)
	src.internal = AAA //Toggle internals.

	src << "<b>\green You have automatically enabled your internals."

	src.job = rank
	src.mind.assigned_role = rank

	src.equip_if_possible(new /obj/item/clothing/head/helmet/space(src), slot_head)

	src.loc = locate(SpawnKartX,SpawnKartY+Current_Spawned_Rank,1)

	var/obj/machinery/vehicle/a = new(locate(SpawnKartX,SpawnKartY+Current_Spawned_Rank,1))
	karts += a
	a.Kart = 1
	a.name = "[name]'s kart"

	if (client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = veh
		client.pixel_y2 = 0
		client.pixel_x = 0
	veh = a
	a.CanMove = 1
	loc = a

	spawn(15)
		src << 'start.wav'

	KartPlayers = KartPlayers + 1
	Current_Spawned_Rank = Current_Spawned_Rank + 2

/datum/game_mode/greytide_racing
	name = "greytide kart"
	config_tag = "greytidekart"
	events_enabled = 0
	do_kick = 1

var/SpawnKartX = 9
var/SpawnKartY = 221
//129,114

/datum/game_mode/greytide_racing/pre_setup()
	..()
	switch(1)
		if(1)
			SpawnKartX = 9
			SpawnKartY = 221
	return 1
/datum/game_mode/greytide_racing/announce()
	world << "<B>The current game mode is - Greytide racing!!</B>"
	world << "<B>Get ready! [MAXIMUM_LAPS] laps in total!</B>"
	Current_Spawned_Rank = 0
	spawn(60+15)
		world << "<font size=6><b>Get a rank better than [max(1,round(KartPlayers/2))] to win!</b>"
		race_started = 1
		world << sound('kart1.ogg',channel=MUSIC_CHANNEL,repeat=1)


/datum/game_mode/greytide_racing/ending()
	world << sound(null)
	world << 'final.wav'
/datum/game_mode/greytide_racing/check_finished()
	var/kartsa = 0
	var/wonkarts = 0

	for(var/obj/machinery/vehicle/k in karts)
		for(var/mob/A as mob in k)
			if(A.client)
				kartsa = kartsa + 1
		if(k.race_won)
			wonkarts = wonkarts + 1
	if(wonkarts >= kartsa)
		world.log << "Beat the game. [kartsa] players - [wonkarts] winners"
		return 1
	return 0

/turf/unsimulated/floor/racing
	icon = 'racing.dmi'
	icon_state = "white"
	var/race_type = 0
	var/check = 0
	start
		icon_state = "white"
		race_type = 2
	concrete
		icon_state = "concrete"
	powerup
		icon_state = "powerup"
		race_type = 3
	checkpoints
		icon_state = "concrete2"
		race_type = 1
		o1
			check = 1
		o2
			check = 2
		o3
			check = 3
		o4
			check = 4
		o5
			check = 5
		o6
			check = 6
		o7
			check = 7
		o8
			check = 8

/obj/machinery/vehicle
	var/checkpoint = 0
	var/race_won = 0
	var/Kart = 0
	var/lastx = 9
	var/lasty = 221
	var/lap = 1
	var/current_item = "none"


/obj/machinery/vehicle/proc/check_point()
	if(race_won)
		return
	var/turf/unsimulated/floor/racing/T = locate(x,y,z)
	if(T && istype(T,/turf/space))
		loc = locate(lastx,lasty,1)
		forward = Vector2_North // Initialize direction to north.
		velocity = Vector2_Zero // Initialize velocity to zero.
		for(var/mob/A as mob in src)
			A << "<font size=5><b>\red You fell from the map!"
			A << 'warn.ogg'
	if(T && istype(T,/turf/unsimulated/floor/racing))
		if(T.race_type == 3 && T.icon_state == "powerup" && current_item == "none")
			T.icon_state = "powerupused"
			get_item()
		if(T.race_type == 1)
			if(src.checkpoint + 1 == T.check)
				lastx = T.x
				lasty = T.y
				src.checkpoint = T.check
		if(T.race_type == 2)
			if(src.checkpoint == 8)
				src.checkpoint = 0
				lap = lap + 1
				forcedloc = locate(x,y,z)
				lastx = x
				lasty = y
				for(var/mob/A as mob in src)
					if(lap < MAXIMUM_LAPS)
						A << 'lap.ogg'
						A << "<font size=6><b>\green Lap [lap]!"
					else
						var/storth = "st" //1 is 1st.
						if(current_place > 1) //2 is 2nd.
							storth = "nd"
						if(current_place > 2) //3 is 3rd.
							storth = "rd"
						if(current_place > 3) //4 is 4th. and so on
							storth = "th"
						var/isgoodplace = max(1,round(KartPlayers/2))
						if(current_place <= isgoodplace)
							A << "<font size=6><b><font color='green'>[current_place][storth] place! Congratulations!"
						else
							A << "<font size=6><b><font color='red'>[current_place][storth] place..."
						world << "<font size=6><b>[name] got [current_place][storth] place!"
						world << 'goal.wav'
						A << sound(null,channel=MUSIC_CHANNEL)
						if(A.client)
							A.client.eye = locate(x,y,z)
						race_won = 1
						var/g = current_place
						spawn(10)
							if(g <= isgoodplace)
								A << sound('win.wav',channel=MUSIC_CHANNEL_ALT)
							else
								A << sound('lose.wav',channel=MUSIC_CHANNEL_ALT)
						current_place = current_place + 1


/obj/item/weapon/bananapeel
	var/can_trip = 1

/proc/vehicle_item_to_text(var/t = "none")
	switch(t)
		if("none")
			return "Nothing"
		if("bananapeel")
			return "Banana Peel"
		if("speed")
			return "High speed"
/obj/machinery/vehicle/proc/use_item()
	if(Kart)
		switch(current_item)
			if("bananapeel")
				var/obj/item/weapon/bananapeel/ge = new(locate(x,y,z))
				ge.can_trip = 0
				spawn(5)
					ge.can_trip = 1
			if("speed")
				spawn()
					for(var/i in 1 to 75)
						sleep(world.tick_lag)
						velocity += forward * (Acceleration() * world.tick_lag)
				for(var/mob/A as mob in src)
					A << 'boost.wav'
		current_item = "none"

#define POSSIBLE_ITEMS list("bananapeel","speed")
/obj/machinery/vehicle/proc/get_item()
	if(current_item == "none")
		current_item = pick(POSSIBLE_ITEMS)
		for(var/mob/A as mob in src)
			A << "<font color='#00FFFF'><b><font size=4>Item : [vehicle_item_to_text(current_item)]!"
			A << 'gotitem.wav'

/mob/verb/drop_vehicle_item()
	set hidden = 1
	set name = "Use_Vehicle_Item"
	if(veh)
		veh.use_item()