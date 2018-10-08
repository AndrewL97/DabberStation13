#define XBOX_360 0
#define DUALSHOCK_3 1
#define SIXAXIS 1

/*

	How to use:
		1) Listen on GamepadConnected(gamepadId) or GamepadDisconnected(gamepadId) for gamepad availability updates, or access the client.gamepads list
		2) Select the desired gamepad and pass it through client.SetDefaultGamepad()
	Known Concerns:
		Chrome has the WORST support for x-input-based controllers, so use Firefox as an alternative.
		Press a button on the controller to activate it.

*/

#ifndef GAMEPAD_ID
#define GAMEPAD_ID "gamepad_window"
#endif

client

	var
		gamepads[0]
		buttons[0]
		abuttons[0]
		axes[0]
		autosetGamepad = TRUE
		currentGamepadType = XBOX_360
		datum/gamepad_focus = null
		datum/last_gamepad_focus = null
		gamepad_input_locked = FALSE

	Topic(href, href_list[], gamepadUpdate/hsrc)

		switch(href_list["action"])

			if("gamepad")

				var id = url_decode(href_list["id"])

				if(id)

					if(text2num(href_list["state"])||(href_list["state"]=="true"))

						src.gamepads += id
						src.GamepadConnected(id)

					else

						src.gamepads -= id
						src.GamepadDisconnected(id)

			if("update_gamepads")

				if(href_list.len >= 2)

					var newGamepads = href_list.Copy(2)

					for(var/foo in newGamepads)
						foo = url_decode(foo)

					src.gamepads		= newGamepads
					var difference[]	= newGamepads ^ src.gamepads

					for(var/bar in difference)

						if(bar in src.gamepads)	src.GamepadConnected(bar)
						else					src.GamepadDisconnected(bar)

			else
				return ..()

	proc

		gamepad_focus_gained(datum/D)
		gamepad_focus_lost(datum/D)

		gamepad_lock_input()gamepad_input_locked = TRUE
		gamepad_unlock_input()gamepad_input_locked = FALSE

		clear_gamepad_input()
			gamepad_unlock_input()
			for(var/b in buttons)
				buttons[b] = 0
			for(var/a in axes)
				axes[a] = 0
			for(var/a in abuttons)
				abuttons[a] = 0

		set_gamepad_focus(x)
			clear_gamepad_input()
			last_gamepad_focus = gamepad_focus
			if(hascall(gamepad_focus,"gamepad_focus_lost")) gamepad_focus:gamepad_focus_lost(src)
			gamepad_focus = x
			if(hascall(gamepad_focus,"gamepad_focus_gained")) gamepad_focus:gamepad_focus_gained(src)

		return_gamepad_focus()
			set_gamepad_focus(last_gamepad_focus)

		// Events:
		GamepadConnected(gamepadId)
			if(autosetGamepad)
				SetDefaultGamepad(gamepadId)
		GamepadDisconnected(/* gamepadId */)

		DownedButton(button)
			if(!isnull(gamepad_focus))gamepad_focus.DownedButton(button,src)
		ReleasedButton(button)
			if(!isnull(gamepad_focus))gamepad_focus.ReleasedButton(button,src)

		// Omit gamepadId to turn it off.
		SetDefaultGamepad(gamepadId)
			src << output(list("SetDefaultGamepad", "[gamepadId]"), "gamepad_window")

		// Call this for Chrome please.
		UpdateGamepads()
			src << output(list("UpdateGamepads"), "gamepad_window")

	verb

		UpdateAxis(axis as num,value as num)
			set hidden = 1
			set instant = 1
			if(gamepad_input_locked) return
			if(!isnull(gamepad_focus))gamepad_focus.UpdateAxis(axis,value,src)
			src.axes["[axis]"] = value
		UpdateAnaButton(button as num,value as num)
			set hidden = 1
			set instant = 1
			if(gamepad_input_locked) return
			if(!isnull(gamepad_focus))gamepad_focus.UpdateAnaButton(button,value,src)
			src.abuttons["[button]"] = value

		UpdateButton(button as num, state as num)

			set hidden = 1
			set instant = 1

			if(gamepad_input_locked) return

			if(!isnull(gamepad_focus))gamepad_focus.UpdateButton(button,state,src)

			if(state)
				src.buttons["[button]"] = 1
				src.DownedButton(button)
			else
				src.buttons["[button]"] = 0
				src.ReleasedButton(button)

datum
	proc
		gamepad_focus_lost(client/C)
		gamepad_focus_gained(client/C)
		DownedButton(button,client/C)
		ReleasedButton(button,client/C)
		UpdateAxis(axis,value,client/C)
		UpdateAnaButton(button,value,client/C)
		UpdateButton(button,state,client/C)
