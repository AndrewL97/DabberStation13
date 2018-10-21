# Dabber Station 13 Docs
Documentation of the server.

License : https://github.com/AlcaroIsAFrick/Dab13/blob/master/LICENSE

# Setup (For server hosts)
Download this repo as a zip. **ADVICE : use github desktop for ability to update at any time**

Compile using Dream Maker (takes usually 20 seconds!) you can also do Compile And Run if you want to do a testrun of how your server's gonna play. If you're gonna do this, make sure the folder with your project is named "dab13" and not "dab13-master" or anything else, it must be dab13 or else Ultra-Safe mode will be enabled.

Use dream daemon to host, Don't use port 9999 or 0, because it enables local testing mode and makes a few debugging stuff enabled.

You need to edit ADMIN_REWORK.dm to change admins. And you need to create a webhook.txt file and webhookAdmin.txt file in the config folder, These are used for the discord webhooks. webhook.txt is a webhook that logs player chat, and webhookAdmin.txt is a adminhelp webhook.

Admins are given very basic administration tools, which might be improved in the future, we're always trying to add new stuff. Those can be found in the admin tab in commands.

To configure your gamemode while ingame, go into the Admin tab in commands and do the Change Gamemode command. where you see this

![Gamemode Config](https://raw.githubusercontent.com/AlcaroIsAFrick/Dab13/master/docs/modepic.png)

For any extra questions, you can head over to our discord which can be found here. https://discord.gg/gAuEREJ

# Admin Tools / Commands
Admin tools aren't that big. But you may suggest new ones to me. Currently we have main admin features like banning, kicking, sounds, teleporting. etc

**BELOW ARE DOCS FOR EDITING STUFF IN THE SERVER**


## List of contents.
1. HOW DOES THE HEIGHT SYSTEM WORK
2. ___MAIN_SHIT.dm

## 1. HOW DOES THE HEIGHT SYSTEM WORK
You can press space to jump, and you can stack ontop other players, stand on lattices (if falling too fast, you will break them and die.)

The Calculations applied here are as follows :

	Y Speed gets decremented by 0.375      (96/256)   on the station (gravity)
	Y Speed gets decremented by 0.09375    (24/256)   on space (low gravity)
	When flying with a jetpack, 0.10546875 (27/256)   is added to the Y velocity every tick you are holding space.
	Y Velocity is set to        5.15625    (1320/256) when you jump.
 
 
 
The values mentioned here can be edited in _A_HEIGHT.dm

## 2. MAIN SHIT
This file holds most defines, and can be used to change job slot amounts. I wouldn't recommend changing any of the defines.
