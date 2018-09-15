/client
	verb/Ping_Server()
		set name = "pingserv"
		set hidden = 1
		var/list/ass = list()
		src << "\red Please wait for servers response. You are currently connected to world port [world.port]."
		for(var/por in ALT_SERVERS)
			if(world.Export("byond://[world.address]:[por]?ping"))
				src << "\green Detected a alternate server running on port [por]."
				ass += por
			else
				src << "\red Server [por] Ping failed."
		var/epic = input(src,"What server do you want to join?","Ping") as null|anything in ass
		if(epic)
			src << "Connecting..."
			if(world.port == epic)
				src << "You are already connected to this server."
			else
				src << link("byond://[world.internet_address]:[epic]")