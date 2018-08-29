//the ultimate anti nigger
//thats funny yo

var/list/client/Player_CID_list = list()

client/New()
	..()
	spawn(10)
		if(key != world.host && world.port != 9999)
			if(!(key in Player_CID_list))
				if(Player_CID_list[key] != null)
					Player_CID_list[key] = computer_id
					src << "<font size=4><font color='red'>we are gonna reconnect you to see if your a bad person or no" //Uh Oh!!!
					src << link("byond://[world.internet_address]:[world.port]")
			else
				if (Player_CID_list[key] != computer_id)
					src << "<font size=4><font color='red'>STOP USING WSOCK YOU FUCKING RETARD" //trolled.
					message_admins("[Player_CID_list[ckey]] is a fucking retard lol ban him")
					del(src)
				else
					Player_CID_list[key] = null //don't bring that message up