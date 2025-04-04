-- wip
function Remove_str_from_buffer(str)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		lines[i] = line:gsub(str, "")
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

return Remove_str_from_buffer
