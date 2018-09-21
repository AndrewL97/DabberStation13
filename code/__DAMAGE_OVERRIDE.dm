/mob
	var/specialloss = 0.0 //you are have the stupidddddddddddddd loooooooooooooooooooooooooooooooooooooo looooooooooooooooooooooooooooooo
	var/old_new_health = 100
	var/old_lying = 0
	var/air = 100

/mob/living/carbon/human
	updatehealth() //this method is not required FUCK YOU
		return
	proc
		reset_damage()
			oxyloss = 0
			toxloss = 0
			fireloss = 0
			bruteloss = 0
			specialloss = 0
		handle_regular_status_updates()
			/*
			uhhhhhhhhhhhhhhh this is the new shit for health like shield and shit i forgot lol
			*/
			breathe()

			air = max(0,min(100,air)) //Clamp values
			if(air < world.tick_lag)
				oxyloss += 0.5
				if(frm_counter % 60 == 1)
					emote("gasp")
			var/new_health = maxhealth - (oxyloss + toxloss + fireloss + bruteloss + specialloss)
			if(shield > 0)
				//world << "shield taking [new_health-health] damage"
				if(new_health < old_new_health)
					shield = max(0,shield+((new_health-old_new_health)*2))
					reset_damage()
				else
					if(new_health > health)
						//world << "Changing health to [new_health], old [health]"
						health = new_health //Heal PLayer damage.
			else
				//world << "2 Changing health to [new_health]"
				health = new_health

			if (src.nodamage)
				health = maxhealth
				shield = 100
			if (src.healths)
				src.healths.icon_state = "health[round(7-((health/maxhealth)*7))]"
			if(src.shields)
				shield = min(100,max(0,shield)) //Clamp the value
				src.shields.icon_state = "shield[round((shield/100)*15)]"
			old_new_health = new_health

			var/updatematrix = 0
			src.rest.icon_state = "rest[src.resting || src.lying]"

			var/matrix/MAT = null
			if((src.lying || src.resting) != src.old_lying)
				updatematrix = 1
				MAT = matrix()
				old_lying = lying || resting
			if ((src.lying || src.resting) && updatematrix)
				MAT.Turn(90)
				MAT.Translate(0,-10)
			if(animating == 0 && updatematrix)
				animating = 1
				animate(src, transform = MAT, time = 5)
				spawn(5)
					animating = 0

			/*

			DONT FUCK WITH OTHER SHIT

			*/
			if(oxyloss > 50) paralysis = max(paralysis, 3)

			if(src.sleeping)
				src.paralysis = max(src.paralysis, 3)
				if (prob(10) && health) spawn(0) emote("snore")
				src.sleeping--

			if(src.resting)
				src.weakened = max(src.weakened, 5)

			if(health < -100 || src.brain_op_stage == 4.0)
				death()
			else if(src.health < 0)
				if(src.health <= 20 && prob(1)) spawn(0) emote("gasp")

				//if(!src.rejuv) src.oxyloss++
				if(!src.reagents.has_reagent("inaprovaline")) src.oxyloss++

				if(src.stat != 2)	src.stat = 1
				src.paralysis = max(src.paralysis, 5)

			if (src.stat != 2) //Alive.

				if (src.paralysis || src.stunned || src.weakened || changeling_fakedeath) //Stunned etc.
					if (src.stunned > 0)
						src.stunned -= world.tick_lag
						src.stat = 0
					if (src.weakened > 0)
						src.weakened -= world.tick_lag
						src.lying = 1
						src.stat = 0
					if (src.paralysis > 0)
						src.paralysis -= world.tick_lag
						src.blinded = 1
						src.lying = 1
						src.stat = 1
					if(paralysis < 0)
						paralysis = 0
					if(weakened < 0)
						weakened = 0
					if(src.stunned < 0)
						src.stunned = 0
					var/h = src.hand
					src.hand = 0
					drop_item()
					src.hand = 1
					drop_item()
					src.hand = h

				else	//Not stunned.
					src.lying = 0
					src.stat = 0

			else //Dead.
				src.lying = 1
				src.blinded = 1
				src.stat = 2

			if (src.stuttering) src.stuttering--

			if (src.eye_blind)
				src.eye_blind--
				src.blinded = 1

			if (src.ear_deaf > 0) src.ear_deaf--
			if (src.ear_damage < 25)
				src.ear_damage -= 0.05
				src.ear_damage = max(src.ear_damage, 0)

			src.density = !(src.resting || src.lying)

			if ((src.sdisabilities & 1 || istype(src.glasses, /obj/item/clothing/glasses/blindfold)))
				src.blinded = 1
			if ((src.sdisabilities & 4 || istype(src.ears, /obj/item/clothing/ears/earmuffs)))
				src.ear_deaf = 1

			if (src.eye_blurry > 0)
				src.eye_blurry--
				src.eye_blurry = max(0, src.eye_blurry)

			if (src.druggy > 0)
				src.druggy--
				src.druggy = max(0, src.druggy)

			return 1
