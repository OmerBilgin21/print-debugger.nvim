function Trim(str)
	return str:match("^%s*(.-)%s*$")
end

return Trim
