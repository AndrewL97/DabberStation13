/area/forest
	icon = 'floors.dmi'
	icon_state = "eartharea"
	forced_lighting = 0
	song = 'music/grass.ogg'
	CAN_GRIFE = 0
	name = "Forest Area"
	parallax_type = 2 //fog type

/obj/structure/forest
	anchored = 1
	density = 1
	icon = 'forest.dmi'
	ex_act()
		return
	Tree1
		icon_state = "tree1"
		name = "Tree"
		pixel_x = -36
		plane = MOB_PLANE
		New()
			..()
			Get_Layer_Y(0.1)
	deco1
		icon = 'grasstiles.dmi'
		icon_state = "2"
		mouse_opacity = 0
		layer = TURF_LAYER
		density = 1
		New()
			..()
			icon_state = "[rand(2,7)]"