local consoles = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

local prints = {
	"python",
	"lua",
}

function Get_selected_text()
	local _, line_start, col_start, _ = unpack(vim.fn.getpos("'<"))
	local _, _, col_end, _ = unpack(vim.fn.getpos("'>"))
	col_end = col_end + 1
	local line = vim.fn.getline(line_start)

	local selected_text = string.sub(line, col_start, col_end)

	return selected_text
end

local M = {}

function M.setup(config)
	config = config or {}

	if config.insert_mode and config.insert_mode.enabled then
		local insert_keymaps = config.insert_mode.keymaps or {}

		for _, key in ipairs(insert_keymaps) do
			vim.keymap.set(
				"i",
				key,
				"<cmd>lua require('print-debugger').debug_function()<CR>",
				{ noremap = true, silent = true }
			)
		end
	end

	if config.visual_mode and config.visual_mode.enabled then
		local visual_keymaps = config.visual_mode.keymaps or {}
		for _, key in ipairs(visual_keymaps) do
			vim.api.nvim_set_keymap(
				"v",
				key,
				'<cmd>lua require("print-debugger").debug_function()<CR>',
				{ noremap = true, silent = true }
			)
		end
	end
end

M.debug_function = function()
	local filetype = vim.bo.filetype
	local consolable = vim.tbl_contains(consoles, filetype)
	local printable = vim.tbl_contains(prints, filetype)
	local mode = vim.api.nvim_get_mode().mode

	if mode == "i" or mode == "v" then
		if printable or consolable then
			local selected_text = mode == "i" and vim.fn.expand("<cword>") or Get_selected_text()

			local snippet = consolable and string.format("console.log('%s: ', %s)", selected_text, selected_text)
				or string.format("print('%s: ', %s)", selected_text, selected_text)

			if mode == "i" then
				vim.api.nvim_command("normal! ciw")
			end
			if mode == "v" then
				vim.cmd('normal! gv"_d')
			end

			vim.api.nvim_put({ snippet }, "c", true, true)

			local cursor = vim.api.nvim_win_get_cursor(0)

			vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #selected_text + 13 })
		end
	end
end

return M
