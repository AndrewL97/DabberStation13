# How to make access
HOW TO MAKE A MAP USING THE ACCESS LEVEL SYSTEM
1. Make a map as normal
2. Select a door that you want to not be accessible to everybody
3. Right click on it and edit its attributes
4. Make the "req_access_txt" attribute be a semicolon-separated list of the permissions required to open the doors
5. Repeat for all doors.

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
