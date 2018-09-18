/*
This will soon work.
*/
proc/atan2(x, y)
	if(!x && !y) return 0
	return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

/obj/item/weapon/gun
	icon = 'guns.dmi'
	icon_state = "caplaser"
	var/ammo = 100
	var/ammo_max = 100
	var/fire_rate = 5
	var/reload_rate = 15
	var/gun_sound = 'shot.ogg'
	var/bullet_speed = 20
	proc/fire(atom/A,mob/user)
		if(ammo > 0)
			if(frm_counter % fire_rate == 1)
				ammo -= 1
				var/obj/projectile/G = new(user.loc)
				var/angle = atan2(A.x-user.x,A.y-user.y)
				G.X_SPEED = cos(angle)*bullet_speed
				G.Y_SPEED = sin(angle)*bullet_speed
				var/matrix/M = matrix()
				M.Turn(angle)
				G.transform = M
				G.owner = user
				playsound(user, gun_sound, 100, 1, 15, 0)
	New()
		..()
		special_processing += src
	Del()
		special_processing -= src
		..()
	special_process()
		if(frm_counter % reload_rate == 1)
			ammo += 1
			if(ammo > ammo_max)
				ammo = ammo_max

/obj/projectile
	icon = 'guns.dmi'
	icon_state = "bullet"
	var/X_SPEED = 0
	var/Y_SPEED = 0
	var/mob/owner = null
	pixel_collision_size_x = 2
	pixel_collision_size_y = 2
	real_pixel_x = 15
	real_pixel_y = 15
	pixel_w = -16
	pixel_z = -16
	pixel_x = 15
	pixel_y = 15
	animate_movement = 0
	density = 0
	New()
		..()
		special_processing += src
	Del()
		special_processing -= src
		..()
	special_process()
		..()
		for(var/mob/e in orange(1,src))
			if(e != owner)
				if(PixelCollision(e))
					e.bruteloss += 5
		if(!PixelMove(X_SPEED,Y_SPEED))
			del src