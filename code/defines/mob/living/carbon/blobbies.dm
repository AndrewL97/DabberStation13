/mob/living/carbon/blobby
	name = "blobby"
	voice_name = "blobby"
	voice_message = "chirps"
	icon = 'blobbies.dmi'
	desc = "Looks slimy."
	icon_state = "grey adult slime"
	pixel_y = -4
	heightSize = 17
	var/l_delay = 0
	gender = NEUTER
	New()
		..()
		var/col = pick("blue","dark blue","green","grey","purple","orange","pink","dark purple","red","yellow","gold","metal","silver","light pink","black","rainbow","adamantite","oil","bluespace","pyrite","sepia","cerulean")
		icon_state = "[col] [pick("baby","adult")] slime"
		src.overlays += image("icon" = 'blobbies.dmi', "icon_state" = "aslime-:)", "layer" = MOB_LAYER)
	Life()
		if(world.time < l_delay)
			return
		if(!client)
			step_rand(src)
			l_delay = world.time+rand(10,20)