/proc/SetupOccupationsList()
	var/list/new_occupations = list()

	for(var/occupation in occupations)
		if (!(new_occupations.Find(occupation)))
			new_occupations[occupation] = 1
		else
			new_occupations[occupation] += 1

	occupations = new_occupations
	return

/mob/living/carbon/human/proc/Equip_Rank(rank, joined_late)
	if(ticker) //	if(joined_late == 1) master_mode
		switch(ticker.mode.name)
			if("normal")
				Spawn_Normal(rank, joined_late)
			if("greytide kart")
				if(joined_late)
					src << "<b>\green Now spectating. Move around!"
					src.ghostize()
					del(src)
				else
					Spawn_Kart(rank, joined_late)
			if("Dab Station 13 Battle Royale")
				if(joined_late)
					src << "<b>\green Now spectating. Move around!"
					src.ghostize()
					del(src)
				else
					Spawn_Fortain(rank, joined_late)
			else
				src << "<b><font color='red'>Something went FUCKING terribly wrong. We weren't able to spawn you correctly. So we are gonna spawn you using the normal method. Please report this bug INMEDIATELY."
				//Custom behaviour here
				Spawn_Normal(rank, joined_late)
	else
		src << "<b><font color='red'>Something went FUCKING terribly wrong. We weren't able to spawn you correctly. So we are gonna spawn you using the normal method. Please report this bug INMEDIATELY."
		Spawn_Normal(rank, joined_late)


/mob/living/carbon/human/proc/Spawn_Normal(rank, joined_late)
	src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
	src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)


	switch(rank)
		if ("Chaplain")
			src.equip_if_possible(new /obj/item/weapon/storage/bible(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/device/pda/chaplain(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/chaplain(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			if(prob(15))
				src.see_invisible = 15

		if ("Geneticist")
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/geneticist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)

		if ("Chemist")
			src.equip_if_possible(new /obj/item/device/pda/toxins(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/geneticist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)

		if ("Janitor")
			src.equip_if_possible(new /obj/item/device/pda/janitor(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)

		if ("Clown")
			src.equip_if_possible(new /obj/item/device/pda/clown(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/clown(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)

			src.equip_if_possible(new /obj/item/weapon/banana(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/bikehorn(src), slot_in_backpack)
			src.mutations |= 16

		if ("Station Engineer")
			src.equip_if_possible(new /obj/item/device/pda/engineering(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/clothing/gloves/yellow(src), slot_gloves)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/device/t_scanner(src), slot_r_store)

		if ("Assistant")
			src.equip_if_possible(new /obj/item/clothing/under/color/grey(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)

		if ("Detective")
			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/det(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/det_hat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/fcardholder(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/clothing/suit/det_suit(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/device/detective_scanner(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/weapon/zippo(src), slot_l_store)

		if ("Medical Doctor")
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), slot_l_hand)

		if ("Captain")
			src.equip_if_possible(new /obj/item/device/pda/captain(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/captain(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/captain(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/caphat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
//			src.equip_if_possible(new /obj/item/weapon/gun/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)


		if ("Security Officer")
			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/color/red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
//			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
//			src.equip_if_possible(new /obj/item/weapon/gun/taser_gun(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/storage/flashbang_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/baton(src), slot_belt)
//			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)


		if ("Scientist")
			src.equip_if_possible(new /obj/item/device/pda/toxins(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/scientist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
//			src.equip_if_possible(new /obj/item/clothing/suit/bio_suit(src), slot_wear_suit)
//			src.equip_if_possible(new /obj/item/clothing/head/bio_hood(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/tank/air(src), slot_l_hand)

		if ("Head of Security")
			src.equip_if_possible(new /obj/item/device/pda/heads(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/head_of_security(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/helmet/HoS(src), slot_head)
//			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
//			src.equip_if_possible(new /obj/item/weapon/gun/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)


		if ("Head of Personnel")
			src.equip_if_possible(new /obj/item/device/pda/heads(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/head_of_personnel(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/helmet(src), slot_head)
//			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
//			src.equip_if_possible(new /obj/item/weapon/gun/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)


		if ("Atmospheric Technician")
			src.equip_if_possible(new /obj/item/clothing/under/rank/atmospheric_technician(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)

		if ("Barman")
			src.equip_if_possible(new /obj/item/clothing/under/bartender(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)

		if ("Chef")
			src.equip_if_possible(new /obj/item/clothing/under/chef(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/chefhat(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/kitchen/rollingpin(src), slot_in_backpack)

		if ("Roboticist")
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/color/black(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/clothing/gloves/latex(src), slot_gloves)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(src), slot_l_hand)

		if ("Hydroponist")
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/under/rank/hydroponics(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/latex(src), slot_gloves)

		if ("Quartermaster")
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/cargo(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/pda/quartermaster(src), slot_belt)
			//src.equip_if_possible(new /obj/item/clothing/suit/exo_suit(src), slot_wear_suit)

		if ("Chief Engineer")
			src.equip_if_possible(new /obj/item/device/pda/heads(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/gloves/yellow(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/glasses/meson(src), slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(src), slot_w_uniform)

		if ("Research Director")
			src.equip_if_possible(new /obj/item/device/pda/heads(src), slot_belt)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/research_director(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/weapon/pen(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/clipboard(src), slot_r_hand)
		else
			world << "<font color='red'><font size=6>We weren't able to load [rank]. Please report this to a coder."
	src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)

	var/obj/item/weapon/tank/air/AAA = new(src)
	src.equip_if_possible(AAA, slot_l_store)
	src.internal = AAA //Toggle internals.

	spawnId(rank)

	world << "<b><font color='#33ccff'>[src] has signed up as [rank]</b>"

	src << "<B>You are the [rank].</B>"
	src.job = rank
	src.mind.assigned_role = rank

	src.equip_if_possible(new /obj/item/clothing/head/helmet/space(src), slot_head)
	//if (!joined_late && rank != "Tourist")
	var/list/rand_spawns = list()
	for(var/obj/machinery/sleeper/spawner/e in world)
		rand_spawns += e
	var/obj/machinery/sleeper/spawner/g = pick(rand_spawns)
	src.loc = g.loc

	return

/mob/living/carbon/human/proc/spawnId(rank)
	var/obj/item/weapon/card/id/C = null
	switch(rank)
		if("Captain")
			C = new /obj/item/weapon/card/id/gold(src)
		else
			C = new /obj/item/weapon/card/id(src)
	var/datum/credit_card/fC = null
	for(var/datum/credit_card/FI in list_dab_cards)
		if(FI.owner == key)
			fC = FI
	if(!fC)
		C.credit = new()
		var/security_code = rand(1000,9999)
		C.credit.code = security_code
		C.credit.InitCard("[key]")
	else
		C.credit = fC //This method is unoptimized, it could be better.
	src << "<b><font color='#00ffff'>Your DabCard security number is : [C.credit.code], You have [C.credit.dabcoins] dabcoins currently. To get more dabcoins, work."
	if(C)
		C.registered = src.real_name
		C.assignment = rank
		C.name = "[C.registered]'s ID Card ([C.assignment]) ([key])"
		C.access = get_access(C.assignment)
		src.equip_if_possible(C, slot_wear_id)
	src.equip_if_possible(new /obj/item/device/flashlight(src), slot_r_store)
	//src.equip_if_possible(new /obj/item/device/radio/signaler(src), slot_belt)
	src.equip_if_possible(new /obj/item/device/pda(src), slot_belt)
	if (istype(src.belt, /obj/item/device/pda))
		src.belt:owner = src.real_name
		src.belt.name = "PDA-[src.real_name]"