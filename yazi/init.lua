require("git"):setup()

function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
        -- elseif os.date("%Y", time) == os.date("%Y") then
    else
        time = os.date("%d/%m/%Y %H:%M", time)
    end

    local size = self._file:size()
    return string.format("%s  %s", size and ya.readable_size(size) or "-", time)
end
