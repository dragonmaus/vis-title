require('vis')

local function set_title(title)
	-- print() cannot be used here as it will mess up vis
	vis:command(string.format(":!printf '\\033]2;vis %s\\007'", title))
end

local function format_path(path)
	if not path then
		return nil
	end
	path, name = path:match("^(.*/)([^/]+)$")
	path = path:gsub("^" .. os.getenv("HOME") .. "/", "~/")
	path = path:gsub("/$", "")
	return string.format("%s (%s)", name, path)
end

vis.events.subscribe(vis.events.INIT, function()
	print('\27[22;2t')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	set_title(format_path(win.file.path) or "[No Name]")
end)

vis.events.subscribe(vis.events.FILE_SAVE_POST, function(file, _)
	set_title(format_path(file.path))
end)

vis.events.subscribe(vis.events.QUIT, function()
	print('\27[23;2t')
end)
