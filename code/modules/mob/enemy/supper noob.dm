proc/GetDist(var/atom/A1, var/atom/A2)
	return max(abs(A1.x-A2.x), abs(A1.y-A2.y))

/mob/enemy/suppernoob //tad unoptimized tbh
	name = "Supper Noob"
	desc = "dead joke from RIS"
	icon = 'big.dmi'
	icon_state = "SUPPER NOOB"
	density = 1
	pixel_w = -32
	maxhealth = 1000 //This thing's op but killable
	heightSize = 72 //dab13 players will be amazed you can stack ontop him
	var
		CurrentWave = 1
		DoingWave = 0
	ex_act()
		return
	EnemyProcess()
		if(!DoingWave)
			spawn()
				DoingWave = 1
				CurrentWave = rand(1,4)
				world << "Starting Wave"
				call(src,"Wave[CurrentWave]")() //Makes a wave happen.
				world << "Finished Wave [CurrentWave]"
				DoingWave = 0
	proc
		GamerJump(ynew)
			ySpeed = ynew
			onFloor = 0
			while(!onFloor)
				sleep(world.tick_lag)
		Wave1()
			//Wave 1 : Jump
			if(onFloor)
				GamerJump(2)
				GamerJump(4)
				GamerJump(8)
				GamerJump(32)
				explosion(src, 1, 5, 7, 0,1)
		Wave2()
			sleep(10)
		Wave3()
			sleep(10)
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
				glide_size = 32 / 0.5 * world.tick_lag
				walk_to(src,nearest_mob,1,0.5,0)