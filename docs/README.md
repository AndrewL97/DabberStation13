# Dabber Station 13 Docs
Documentation of the server.

# Setup (For server hosts)
Download this repo as a zip. **ADVICE : use github desktop for ability to update at any time**

Compile using Dream Maker (takes usually 20 seconds!) you can also do Compile And Run if you want to do a testrun of how your server's gonna play. If you're gonna do this, make sure the folder with your project is named "dab13" and not "dab13-master" or anything else, it must be dab13 or else Ultra-Safe mode will be enabled.

Use dream daemon to host, Don't use port 9999 or 0, because it enables local testing mode and makes a few debugging stuff enabled.

You need to edit ADMIN_REWORK.dm to change admins. And you need to create a webhook.txt file and webhookAdmin.txt file in the config folder, These are used for the discord webhooks. webhook.txt is a webhook that logs player chat, and webhookAdmin.txt is a adminhelp webhook.

Gamemodes cannot be configured yet. I plan to add configuration for it soon.

# Admin Tools / Commands
Admin tools aren't that big. But you may suggest new ones to me. Currently we have main admin features like banning, kicking, sounds, teleporting. etc

**BELOW ARE DOCS FOR EDITING STUFF IN THE SERVER**


## List of contents.
1. HOW TO MAKE A MAP USING THE ACCESS LEVEL SYSTEM
2. HOW DOES THE HEIGHT SYSTEM WORK
3. ___MAIN_SHIT.dm

## 1. HOW TO MAKE A MAP USING THE ACCESS LEVEL SYSTEM
1- Make a map as normal

2- Select a door that you want to not be accessible to everybody

3- Right click on it and edit its attributes

4- Make the "req_access_txt" attribute be a semicolon-separated list of the permissions required to open the doors

5- Repeat for all doors.


For example, a brig door would have it be "2" while a door that requires you have toxins and teleporter access (for whatever reason) would have it be "9;20"

Here is a list of the permissions and their numbers (this may be out of date, see code/game/access.dm for an updated version):

	access_security = 1
	access_brig = 2
	access_security_lockers = 3
	access_forensics_lockers= 4
	access_security_records = 5
	access_medical_supplies = 6
	access_medical_records = 7
	access_morgue = 8
	access_tox = 9
	access_tox_storage = 10
	access_medlab = 11
	access_engine = 12
	access_eject_engine = 13
	access_maint_tunnels = 14
	access_external_airlocks = 15
	access_emergency_storage = 16
	access_apcs = 17
	access_change_ids = 18
	access_ai_upload = 19
	access_teleporter = 20
	access_eva = 21
	access_heads = 22
	access_captain = 23
	access_all_personal_lockers = 24
	access_chapel_office = 25
	access_tech_storage = 26
	access_atmospherics = 27
	access_bar = 28
	access_janitor = 29
	access_disposal_units = 30

## 2. HOW DOES THE HEIGHT SYSTEM WORK
You can press space to jump, and you can stack ontop other players, stand on lattices (if falling too fast, you will break them and die.)

The Calculations applied here are as follows :

	Y Speed gets decremented by 0.375      (96/256)   on the station (gravity)
	Y Speed gets decremented by 0.09375    (24/256)   on space (low gravity)
	When flying with a jetpack, 0.10546875 (27/256)   is added to the Y velocity every tick you are holding space.
	Y Velocity is set to        5.15625    (1320/256) when you jump.
 
 
 
The values mentioned here can be edited in _A_HEIGHT.dm

## 3. MAIN SHIT
This file holds most defines, and can be used to change job slot amounts. I wouldn't recommend changing any of the defines.
