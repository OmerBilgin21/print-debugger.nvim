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

function Trim(str)
	return str:match("^%s*(.-)%s*$")
end

local M = {}

function M.setup(config)
	config = config or {}

	if config.keymaps then
		for _, key in ipairs(config.keymaps) do
			vim.keymap.set(
				{ "i", "x", "n", "s" },
				key,
				"<cmd>lua require('print-debugger').debug_function()<CR>",
				{ noremap = true, silent = true }
			)
		end
	end
end

M.debug_function = function()
	local filetype = vim.bo.filetype
	local consolable = vim.tbl_contains(consoles, filetype)
	local printable = vim.tbl_contains(prints, filetype)

	if printable or consolable then
		local selected_text = Trim(vim.fn.getline("."))

		local snippet = consolable and string.format("console.log('%s: ', %s)", selected_text, selected_text)
			or string.format("print('%s: ', %s)", selected_text, selected_text)

		vim.api.nvim_command("normal! d0D")

		vim.api.nvim_put({ snippet }, "c", true, true)

		local cursor = vim.api.nvim_win_get_cursor(0)

		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #selected_text + 13 })
	end
end

return M
