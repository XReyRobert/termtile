on run argv
	global _cache
	set _cache to {}

	set ScreenUtils to load script alias ((path to me as text) & "::screenUtils.scpt")
	set _config to run script alias ((path to me as text) & "::config.scpt")

	set _terminalApp to terminalApp of _config

	set _marginV to marginV of _config
	set _marginH to marginH of _config
	set _directions to parseArguments(argv)

	if (count of _directions) < 1 then
		return -1
	end if

	try
		tell ScreenUtils to set _screen to getScreenWithFrontmostWindowOfApp(_terminalApp)
	on error
		return
	end try

	using terms from application "Terminal"
		tell application _terminalAppa
			-- Terminal is kind of wierd
			if _terminalApp = "Terminal" then
				set originY of _screen to 23
			end if

			if (count of _directions) = 1 then
				set _direction to item 1 of _directions
				if _direction = up then
					set bounds of window 0 to {originX of _screen + _marginH, originY of _screen + _marginV, (originX of _screen) + (width of _screen - _marginH/2), (originY of _screen) + (height of _screen) / 2 - _marginV}
				else if _direction = down then
					set bounds of window 0 to {originX of _screen + _marginH, (originY of _screen + _marginV ) + (height of _screen) / 2 + _marginV, (originX of _screen) + (width of _screen)-_MarginH, (originY of _screen) + (height of _screen - _marginV)}
				else if _direction = left then
					set bounds of window 0 to {originX of _screen + _marginH, originY of _screen + _marginV , (originX of _screen) + (width of _screen) / 2 - _marginH/2, (originY of _screen) + (height of _screen - _marginV)}
				else (* _direction = right *)
					set bounds of window 0 to {(originX of _screen) + (width of _screen) / 2 + _marginH/2, originY of _screen + _marginV , (originX of _screen) + (width of _screen) - _marginH, (originY of _screen) + (height of _screen - _marginV)}
				end if
			else
				set _horizontal to horizontal of _directions
				set _vertical to vertical of _directions
				if _vertical = up and _horizontal = left then
					set bounds of window 0 to {originX of _screen + _marginH, originY of _screen + _marginV , (originX of _screen) + (width of _screen) / 2 - _marginH / 2, (originY of _screen) + (height of _screen) / 2 -  _marginV/2}
				else if _vertical = up and _horizontal = right then
					set bounds of window 0 to {(originX of _screen) + (width of _screen) / 2 + _marginH/2, originY of _screen + _marginV , (originX of _screen) + (width of _screen - _marginH), (originY of _screen) + (height of _screen) / 2 - _marginV/2}
				else if _vertical = down and _horizontal = left then
					set bounds of window 0 to {originX of _screen + _marginH, (originY of _screen + _marginV/2 ) + (height of _screen) / 2, (originX of _screen) + (width of _screen) / 2 - _marginH/2, (originY of _screen) + height of _screen - _marginV}
				else if _vertical = down and _horizontal = right then
					set bounds of window 0 to {(originX of _screen) + (width of _screen) / 2 + _marginH/2, (originY of _screen + _marginV/2 ) + (height of _screen) / 2, (originX of _screen) + (width of _screen - _marginH), (originY of _screen) + (height of _screen - _marginV)}
				end if
			end if
		end tell
	end using terms from
end run

on parseArguments(argv)
	if (count of argv) < 1 then
		return {}
	end if

	set _horizontal to false
	set _vertical to false

	if item 1 of argv = "up" then
		set _vertical to up
	else if item 1 of argv = "down" then
		set _vertical to down
	else if item 1 of argv = "left" then
		set _horizontal to left
	else if item 1 of argv = "right" then
		set _horizontal to right
	end if

	if (count of argv) > 1 then
		if item 2 of argv = "left" then
			set _horizontal to left
		else if item 2 of argv = "right" then
			set _horizontal to right
		end if
	end if

	if _horizontal = false and _vertical = false then
		return {}
	else if _horizontal = false then
		return {_vertical}
	else if _vertical = false then
		return {_horizontal}
	end if

	return {horizontal:_horizontal, vertical:_vertical}
end parseArguments
