/*
This currently works, but the damage method could be redone.
*/
proc/atan2(x, y)
	if(!x && !y) return 0
	return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

/obj/item/weapon/gun
	icon = 'guns.dmi'
	icon_state = "gun"
	desc = "A gun"
	var/automatic = 0
	var/ammo = 0
	var/ammo_max = 0
	var/fire_rate = 0
	var/reload_rate = 0
	var/gun_sound = 'shot.ogg'
	var/bullet_speed = 0
	var/bullet_damage = 0
	var/automatic_reload = 0
	var/sound_range = 15
	machine_gun
		icon_state = "gun"
		automatic = 1
		ammo = 50
		ammo_max = 50
		fire_rate = 5
		reload_rate = 15
		gun_sound = 'shot.ogg'
		bullet_speed = 16
		bullet_damage = 2
		automatic_reload = 1
	pistol
		icon_state = "pistol"
		automatic = 0
		ammo = 24
		ammo_max = 24
		gun_sound = 'shot2.ogg'
		bullet_speed = 20
		bullet_damage = 10
		sound_range = 25 //alot louder
	proc/fire(mob/user,xoff,yoff)
		if(ammo > 0)
			if(automatic == 1)
				if(frm_counter % fire_rate == 1)
					ammo -= 1
					var/obj/projectile/G = new(user.loc)
					G.real_pixel_y = 15+user.heightZ
					G.pixel_y = G.real_pixel_y
					var/angle = atan2((xoff+32)-((G.x*32)+G.real_pixel_x),(yoff+32)-((G.y*32)+G.real_pixel_y))
					G.X_SPEED = cos(angle)*bullet_speed
					G.Y_SPEED = sin(angle)*bullet_speed
					G.damage = bullet_damage
					G.owner = user
					playsound(user, gun_sound, 100, 1, sound_range, 0)
			else
				ammo -= 1
				var/obj/projectile/G = new(user.loc)
				G.real_pixel_y = 15+user.heightZ
				G.pixel_y = G.real_pixel_y
				var/angle = atan2((xoff+32)-((G.x*32)+G.real_pixel_x),(yoff+32)-((G.y*32)+G.real_pixel_y))
				G.X_SPEED = cos(angle)*bullet_speed
				G.Y_SPEED = sin(angle)*bullet_speed
				G.damage = bullet_damage
				G.owner = user
				playsound(user, gun_sound, 100, 1, sound_range, 0)
	New()
		..()
		special_processing += src
	Del()
		special_processing -= src
		..()
	special_process()
		desc = "A gun, it seems to hold [ammo]/[ammo_max] ammunition.<br><b>Extra stats : </b><br><br>Bullet Speed : [bullet_speed]<br>Reload Rate : [reload_rate]<br>Fire Rate : [fire_rate]"
		if(automatic_reload)
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
	var/damage = 5
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
					e.bruteloss += damage
		if(!PixelMove(X_SPEED,Y_SPEED))
			del src