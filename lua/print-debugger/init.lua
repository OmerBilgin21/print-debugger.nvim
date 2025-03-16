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
	local selected_text = Trim(vim.fn.getline("."))
	local snippet, offset

	if filetype == "go" then
		snippet = string.format('fmt.Printf("%s: %%v\\n", %s)', selected_text, selected_text)
		offset = #selected_text + 14
	else
		local consolable = vim.tbl_contains(consoles, filetype)
		local printable = vim.tbl_contains(prints, filetype)

		if consolable then
			snippet = string.format("console.log('%s: ', %s)", selected_text, selected_text)
		elseif printable then
			snippet = string.format("print('%s: ', %s)", selected_text, selected_text)
		else
			return
		end
		offset = #selected_text + 13
	end

	vim.api.nvim_command("normal! d0D")
	vim.api.nvim_put({ snippet }, "c", true, true)

	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + offset })
end

return M
