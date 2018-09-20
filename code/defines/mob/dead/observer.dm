/mob/dead/observer
	icon = 'mob.dmi'
	icon_state = "ghost"
	layer = 4
	density = 0
	stat = 2
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	var/mob/corpse = null	//	observer mode
	var/datum/hud/living/carbon/hud = null // hud
	ex_act(severity)
		shake_camera(src, 1, 10/severity)