/mob
	var/specialloss = 0.0 //you are have the stupidddddddddddddd loooooooooooooooooooooooooooooooooooooo looooooooooooooooooooooooooooooo
	var/old_new_health = 100
	var/old_lying = 0
	var/air = 25
	var/matrix/Angle = matrix()
	var/current_angle = 0 //I'm Stood. A 90 would mean I'm down.
	var/current_angle_speed = 0 //Angle speed
	var/old_angle = 0

/mob/proc/TakeBruteDamage(damage)
	if(istype(src,/mob/living/carbon/human))
		bruteloss += damage/(1+(src:wear_suit ? 1 : 0))
	else
		bruteloss += damage
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

			air = max(0,min(25,air)) //Clamp values
			if(air < tick_lag_original)
				oxyloss += 0.5
				if(frm_counter % 160 == 1)
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
			if(src.rest)
				src.rest.icon_state = "rest[src.resting || src.lying]"

			if((src.lying || src.resting) != src.old_lying)
				old_lying = lying || resting
			if(current_angle_speed > 0)
				var/check = current_angle > 80 && current_angle < 100 && current_angle_speed < 2
				current_angle_speed += max(-world.tick_lag,min(world.tick_lag,((check-current_angle_speed)/100)))
				if(check)
					current_angle += (90-current_angle)/10
					if(round(current_angle,2) == 90)
						current_angle_speed = 0
						Jump()
				else
					current_angle += current_angle_speed
			if(current_angle < 0 || current_angle > 360)
				current_angle = round(current_angle) % 360
			if(round(current_angle) != old_lying*90 && round(current_angle_speed) == 0)
				current_angle += ((old_lying*90)-current_angle)/10

			if (round(current_angle) != old_angle)
				Angle = matrix()
				Angle.Turn(round(current_angle))
				//Angle.Translate(0,round(current_angle)/90)
				old_angle = round(current_angle)
				transform = Angle
				if(MyShadow)
					MyShadow.transform = transform
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
				if(!src.reagents.has_reagent(/datum/reagent/inaprovaline)) src.oxyloss++

				if(src.stat != 2)	src.stat = 1
				src.paralysis = max(src.paralysis, 5)

			if (src.stat != 2) //Alive.

				if (src.paralysis || src.stunned || src.weakened || changeling_fakedeath) //Stunned etc.
					if (src.stunned > 0)
						src.stunned -= tick_lag_original
						src.stat = 0
					if (src.weakened > 0)
						src.weakened -= tick_lag_original
						src.lying = 1
						src.stat = 0
					if (src.paralysis > 0)
						src.paralysis -= tick_lag_original
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
