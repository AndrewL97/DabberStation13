atom
	proc
		Get_Position_X()
			return (x*world.icon_size) + pixel_x + pixel_w
		Get_Position_Y()
			return (y*world.icon_size) + pixel_y + pixel_z
		pixel_hit(atom/A)
atom/movable
	var
		real_pixel_x = 0
		real_pixel_y = 0
		pixel_collision_size_x = 32
		pixel_collision_size_y = 32
	Get_Position_X()
		return (x*world.icon_size) + real_pixel_x
	Get_Position_Y()
		return (y*world.icon_size) + real_pixel_y
	proc
		GetCollisionSizes()
			var/icon/I = new(icon)
			pixel_collision_size_x = I.Width()
			pixel_collision_size_y = I.Height()
			del I
		PixelCollision(atom/a)
			var/st1 = Get_Position_X()+pixel_collision_size_x >= a.Get_Position_X()
			var/st2 = Get_Position_X() <= a.Get_Position_X()+world.icon_size

			var/st3 = Get_Position_Y()+pixel_collision_size_y >= a.Get_Position_Y()
			var/st4 = Get_Position_Y() <= a.Get_Position_Y()+world.icon_size

			return (st1 && st2 && st3 && st4)*a.density
		PixelCollision2(atom/movable/a)
			var/st1 = Get_Position_X()+pixel_collision_size_x >= a.Get_Position_X()
			var/st2 = Get_Position_X() <= a.Get_Position_X()+a.pixel_collision_size_x

			var/st3 = Get_Position_Y()+pixel_collision_size_y >= a.Get_Position_Y()
			var/st4 = Get_Position_Y() <= a.Get_Position_Y()+a.pixel_collision_size_y

			return (st1 && st2 && st3 && st4)*a.density
		PixelMove(var/x_to_move,var/y_to_move,var/ignore)
			var/old_real_x = real_pixel_x
			var/old_real_y = real_pixel_y
			var/old_x = x
			var/old_y = y

			real_pixel_x += x_to_move
			real_pixel_y += y_to_move

			var pixel_x_to_move = round(real_pixel_x, 32)
			real_pixel_x -= pixel_x_to_move
			x += pixel_x_to_move / 32

			var pixel_y_to_move = round(real_pixel_y, 32)
			real_pixel_y -= pixel_y_to_move
			y += pixel_y_to_move / 32

			var/bumpedwalls = 0
			for(var/atom/e in orange(1,src))
				if(e != ignore)
					if(!istype(e,/mob))
						if(PixelCollision(e))
							if(istype(src,/obj/machinery/vehicle))
								if(round(src:velocity:SquareMagnitude()/50) > 80)
									explosion(e, 2, 3, 5, 10,0)
									del src
								else
									bumpedwalls += 1
							else
								pixel_hit(e)
								bumpedwalls += 1
					else
						if(PixelCollision2(e))
							pixel_hit(e)

			if(bumpedwalls > 0)
				x = old_x
				y = old_y
				real_pixel_y = old_real_y
				real_pixel_x = old_real_x
				return 0 //Didn't move
			else
				pixel_x = real_pixel_x
				pixel_y = real_pixel_y
				return 1 //Did move.