#define CHECK_IP_TIMES 3

/*
anti nigger system
*/
var/list/client/Player_CID_list = list()

client/proc/check_ip_if_local()
	var/list/splitted_list_world = splittext("[world.address]",".")
	var/list/splitted_list_client = splittext("[address]",".")
	var/checks = 0
	for(var/i in 1 to CHECK_IP_TIMES)
		if(splitted_list_world[i] == splitted_list_client[i])
			checks += 1
	if(checks == CHECK_IP_TIMES)
		return 1
	else
		return 0
client/New()
	..()
	spawn(10)
		if(key != world.host || !check_ip_if_local())
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