/turf/unsimulated/snow
	icon = 'floors.dmi'
	name = "snow"
	icon_state = "snow"
	water
		icon = 'extra images/water2.dmi'
		icon_state = "snad"
		name = "sand"
		layer = 1.99
		TurfStepSound = list('footstepw1.ogg','footstepw2.ogg','footstepw3.ogg')
		New()
			..()
			overlays += new /image/water()
		sand1
			icon_state = "snad"
		sand2
			icon_state = "snad2"

/turf/unsimulated/grass
	icon = 'grasstiles.dmi'
	name = "grass"
	icon_state = "1"

/obj/greenland
	density = 1
	layer = MOB_LAYER + 1
	anchored = 1
	icon = 'greenland.dmi'
	ex_act()
		return
	Move()
		return
	snowy_tree
		pixel_x = -23
		icon_state = "tree"
/area/greenland
	icon = 'floors.dmi'
	icon_state = "snowarea"
	forced_lighting = 0
	ambi = 0
	CAN_GRIFE = 0 //this is not even funny ikea stop torturing me