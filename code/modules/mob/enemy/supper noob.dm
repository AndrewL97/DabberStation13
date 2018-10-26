proc/GetDist(var/atom/A1, var/atom/A2)
	return max(abs(A1.x-A2.x), abs(A1.y-A2.y))

/mob/enemy/suppernoob //tad unoptimized tbh
	name = "Supper Noob"
	desc = "dead joke from RIS"
	icon = 'big.dmi'
	icon_state = "SUPPER NOOB"
	density = 1
	pixel_x = -32
	maxhealth = 1000 //This thing's op but killable
	heightSize = 72 //dab13 players will be amazed you can stack ontop him
	var
		CurrentWave = 1
		DoingWave = 0
		Cooldown = 1
	ex_act()
		return
	EnemyProcess()
		if(!DoingWave)
			spawn()
				DoingWave = 1
				CurrentWave = rand(1,4)
				//world << "Starting Wave"
				call(src,"Wave[CurrentWave]")() //Makes a wave happen.
				//world << "Finished Wave [CurrentWave]"
				sleep(Cooldown)
				DoingWave = 0
	proc
		ScreamBullshit(ass)
			world << "<b><font color='red'>SUPPER NOOB : [ass]"
		GamerJump(ynew)
			ySpeed = ynew
			onFloor = 0
			while(!onFloor)
				sleep(world.tick_lag)
		Wave1()
			//Wave 1 : Jump
			ScreamBullshit("YOURE ALL FUCKING IDIOTS!!!!!!!!!")
			if(onFloor)
				GamerJump(2)
				GamerJump(4)
				GamerJump(8)
				GamerJump(16)
				ScreamBullshit("DIE!!!!!!!!!!!")
				GamerJump(32)
				explosion(src, 0, 0, 7, 0,1)
				GamerJump(64)
			Cooldown = 30
		Wave2()
			Wave4()
			ScreamBullshit("NIGGERFAGGOT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			for(var/i in 1 to 12)
				var/obj/projectile/G = new(locate(x,y,z))
				G.owner = src
				G.X_SPEED = cos(i*30)*5
				G.Y_SPEED = sin(i*30)*5
			Cooldown = 50
		Wave3()
			Wave4()
			Wave2()
		Wave4()
			//Wave 4 : Search for a enemy.
			var
				nearest_dist = 50 //search dist
				mob/nearest_mob = null
			for(var/mob/i in Mobs)
				if(i.type != type) //Yo dont kill my friends!!!!!!!!!!!!!!!!!!!!!!!!!!
					var/dist = GetDist(src,i)
					if(dist < nearest_dist)
						nearest_mob = i
						nearest_dist = dist
			if(nearest_mob)
				new /obj/Particle/crosshair(nearest_mob.loc)
				dir = get_dir(src,nearest_mob)
				ScreamBullshit("EPIC GRENADE ATTACK!!!!!!!!!!")
				var/obj/item/weapon/grenade/explosiongrenade/G = new(loc)
				G.thrown(src)
				G.icon_state = "flashbang1"
				spawn( G.det_time )
					G.prime()
				spawn(20)
					walk_to(src,nearest_mob,4,5,0)
					glide_size = 32 / 5 * tick_lag_original
				Cooldown = 60