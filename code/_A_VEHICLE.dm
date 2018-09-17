/*

VEHICLES

*/
proc/Get_Position_X(atom/a)
	return (a.x*world.icon_size) + a.pixel_x + a.pixel_w
proc/Get_Position_Y(atom/a)
	return (a.y*world.icon_size) + a.pixel_y + a.pixel_z

atom/movable
	var
		real_pixel_x = 0
		real_pixel_y = 0
		pixel_collision_size_x = 32
		pixel_collision_size_y = 32

	proc
		GetCollisionSizes()
			var/icon/I = new(icon)
			pixel_collision_size_x = I.Width()
			pixel_collision_size_y = I.Height()
			del I
		PixelCollision(atom/a)
			var/st1 = Get_Position_X(src)+pixel_collision_size_x > Get_Position_X(a)
			var/st2 = Get_Position_X(src) < Get_Position_X(a)+world.icon_size

			var/st3 = Get_Position_Y(src)+pixel_collision_size_y > Get_Position_Y(a)
			var/st4 = Get_Position_Y(src) < Get_Position_Y(a)+world.icon_size

			return st1 || st2 || st3 || st4
		PixelMove(var/x_to_move,var/y_to_move)
			var/old_real_x = real_pixel_x
			var/old_real_y = real_pixel_y
			var/old_x = x
			var/old_y = y

			real_pixel_x = real_pixel_x + x_to_move
			real_pixel_y = real_pixel_y + y_to_move

			/*var/pixel_x_to_move = round(real_pixel_x, 32)
			real_pixel_x -= pixel_x_to_move
			x += pixel_x_to_move / 32

			var/pixel_y_to_move = round(real_pixel_y, 32)
			real_pixel_y -= pixel_y_to_move
			y += pixel_y_to_move / 32*/
			while(real_pixel_x > 32) //Modulo doesn't work with this kind of stuff, don't know if there's a better method.
				real_pixel_x = real_pixel_x - 32
				x = x + 1
			while(real_pixel_x < -32)
				real_pixel_x = real_pixel_x + 32
				x = x - 1
			while(real_pixel_y > 32) //Modulo doesn't work with this kind of stuff, don't know if there's a better method.
				real_pixel_y = real_pixel_y - 32
				y = y + 1
			while(real_pixel_y < -32)
				real_pixel_y = real_pixel_y + 32
				y = y - 1

			var/bumpedwalls = 0
			for(var/atom/e in range(1,src))
				if(e.density == 1 && !istype(e,/mob))
					if(PixelCollision(e))
						bumpedwalls += 1
			if(bumpedwalls > 0)
				x = old_x
				y = old_y
				real_pixel_y = old_real_y
				real_pixel_x = old_real_x

				pixel_x = real_pixel_x
				pixel_y = real_pixel_y
				return 0
			else
				pixel_x = real_pixel_x
				pixel_y = real_pixel_y
				return 1
/*
Basic trigonometry

vx = v * cos(angle)
vy = v * sin(angle)
*/

/obj/machinery/vehicle
	name = "Vehicle Pod"
	icon = 'escapepod.dmi'
	icon_state = "recon"
	anchored = 1.0
	animate_movement = 0 //set it
	var/forcedloc = null
	var
		AngleA = 90
		AngleA_Speed = 0
		CanMove = 0
		Processing = 0
		Spinning = 0 ///obj/item/weapon/bananapeel

	New()
		..()
		special_processing += src
		var/icon/E = icon('escapepod.dmi',"recon")
		var/icon/I = icon('escapepod.dmi',"overlay")
		I += rgb(rand(0,255),rand(0,255),rand(0,255))
		I.Blend(E,ICON_OVERLAY)
		icon = I
		del E
		del I
	Del()
		special_processing -= src
		..()


/obj/machinery/vehicle/special_process()
	if(src.Kart == 1)
		check_point()
	if(CanMove == 1)
		if(Kart == 1)
			if(race_started == 0)
				AngleA = 90
				AngleA_Speed = 0
		var/matrix/M = matrix() //create matrix
		M.Turn(-AngleA - 90) //reverse angle
		src.transform = M

		if(Kart == 1)
			if(Spinning > 0)
				AngleA_Speed = 0
				AngleA = AngleA + 20
				Spinning = Spinning - world.tick_lag
			var/peels = 0
			for(var/obj/item/weapon/bananapeel/g in loc)
				if(g.can_trip)
					peels = peels + 1
					del g
			if(peels > 0)
				for(var/mob/A as mob in src)
					A << 'cpuspin.wav'
				Spinning = 5

		if(AngleA_Speed < -4)
			AngleA_Speed = -4
		if(AngleA_Speed > 4)
			AngleA_Speed -= 0.2
		if(AngleA_Speed > 0)
			AngleA_Speed -= 0.01
			if(AngleA_Speed < 0)
				AngleA_Speed = 0
		if(AngleA_Speed < 0)
			AngleA_Speed += 0.01
			if(AngleA_Speed > 0)
				AngleA_Speed = 0

		var/vx = AngleA_Speed * cos(AngleA)
		var/vy = AngleA_Speed * sin(AngleA)

		if(PixelMove(vx,vy)==0)
			AngleA_Speed = AngleA_Speed * -1



		for(var/mob/A as mob in src)
			if(Kart == 1)
				if(!race_won)
					var/sound/AS = sound('engine.ogg')
					AS.repeat = 1
					AS.frequency = abs(AngleA_Speed + 1)
					AS.channel = MOTOR_CHANNEL //Channel 900 is used for epic sound effects
					A << AS

			if(A.client)
				if(Kart == 0)
					A.client.pixel_x = pixel_x
					A.client.pixel_y2 = pixel_y
					A.client.Process_Kart_Racing()
				else
					if(!race_won)
						A.client.pixel_x = pixel_x
						A.client.pixel_y2 = pixel_y
						A.client.Process_Kart_Racing()
					else
						A.client.eye = forcedloc
						A << sound(null, channel = MOTOR_CHANNEL)
	else
		var/matrix/M = matrix()
		M.Turn(90)
		pixel_x = 0
		pixel_y = 0
		transform = M
/obj/machinery/vehicle/meteorhit(var/obj/O as obj)
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
	del(src)

/obj/machinery/vehicle/ex_act(severity)
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
		A.ex_act(severity)
	del(src)

/obj/machinery/vehicle/blob_act()
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
	del(src)

/obj/machinery/vehicle/Bump(var/atom/A)
	//world << "[src] bumped into [A]"
	spawn()
		AngleA_Speed = 0

/obj/machinery/vehicle/relaymove(mob/user as mob, direction)
	if (user.stat)
		return

	if ((user in src))
		if(direction & SOUTH)
			AngleA_Speed = AngleA_Speed - 0.1
		if(direction & NORTH)
			AngleA_Speed = AngleA_Speed + 0.1
		if(direction & EAST)
			AngleA = AngleA - 1
		if(direction & WEST)
			AngleA = AngleA + 1




/mob
	var/obj/machinery/vehicle/veh = null
	var/changingPOD = 0
	var/can_exit_pod = 1

/mob/verb/podCon()
	set name = "Pod Enter/Exit"
	var/mob/M = src
	if(!can_exit_pod)
		src << "<b>\red You cannot do this!"
		return
	if(changingPOD)
		return
	if(veh)
		changingPOD = 1
		veh.CanMove = 0
		sleep(5)
		M.loc = veh.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE
			M.client.pixel_y2 = 0
			M.client.pixel_x = 0
		src << sound(null, channel=MOTOR_CHANNEL)
		veh.AngleA_Speed = 0
		veh = null
		changingPOD = 0
	else
		if(istype(src,/mob/dead) && src.health > 0 )
			return //Can't do this you fucking idiot
		var/list/faf = list()
		for(var/obj/machinery/vehicle/fef in oview(1))
			faf += fef
		var/obj/machinery/vehicle/a = input("Which pod to board?","Board") in faf

		if(a && istype(a,/obj/machinery/vehicle))
			if (locate(/mob, a))
				src << "<b>\red There is no room!"
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = veh
				M.client.pixel_y2 = 0
				M.client.pixel_x = 0
			M.veh = a
			a.CanMove = 1
			a.AngleA_Speed = 0
			M.loc = a
