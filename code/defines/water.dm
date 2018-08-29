/turf/simulated/floor/plating/water
	icon = 'extra images/water2.dmi'
	layer = 1.99
	TurfStepSound = list('footstepw1.ogg','footstepw2.ogg','footstepw3.ogg')
	water_height = 1
	New()
		..()
		spawn(2)
			Render_Water_Icon()
	sand1
		icon_state = "snad"
	sand2
		icon_state = "snad2"
	sand3moreflooded
		icon_state = "snad"
		water_height = 4

image
	water
		icon = 'extra images/water2.dmi'
		icon_state = "wateranim"
		pixel_y = -1
		alpha = 55
		layer = 1.995