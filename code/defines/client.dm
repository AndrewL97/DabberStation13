/client

	var/listen_ooc = 1
	var/move_delay = 1
	var/moving = null
	var/vote = null
	var/showvote = null
	var/adminobs = null
	var/deadchat = 0.0
	var/changes = 0
	var/canplaysound = 1
	var/ambience_playing = null
	var/no_ambi = 0
	var/area = null
	var/played = 0
	var/team = null
	var/buildmode = 0
	var/stealth = 0
	var/fakekey = null
	var/warned = 0

	New()
		winset(src, null, "command=\".configure graphics-hwmode on\"")
		winset(src, "mapwindow.map", "zoom-mode=distort")
		..()
	verb
		github()
			set hidden = 1
			src << link("https://github.com/AlcaroIsAFrick/Dab13")