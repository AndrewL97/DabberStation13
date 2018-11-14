/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition)
			src.nutrition -= tick_lag_original/2
		if(src.mutations & 32 && src.m_intent == "run")
			src.bodytemperature += 2

/mob/living/carbon/gib(give_medal)
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("\red <B>[M] bursts out of [src]!</B>"), 2)
	. = ..(give_medal)