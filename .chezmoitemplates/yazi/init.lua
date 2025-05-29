require("git"):setup({ order = 500 })

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	local timefmt = ""
	if time ~= 0 then
		-- timefmt = ""
		-- elseif os.date("%Y", time) == os.date("%Y") then
		-- else
		timefmt = os.date("%d/%m/%Y %H:%M", time)
	end

	local size = self._file:size()
	return string.format("%s  %s", size and ya.readable_size(size) or "-", timefmt)
end
