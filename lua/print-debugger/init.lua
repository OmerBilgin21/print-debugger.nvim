local trim = require("print-debugger.trim")

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

local echos = {
	"bashrc",
	"zshrc",
	"sh",
	"zsh_aliases",
	"zsh_env",
	"bash_aliases",
	"bash_env",
	"bash",
	"zsh",
	"shell",
	"tmux",
	"config",
	"dotenv",
	"conf",
	"profile",
	"aliases",
}

local M = {}

M.debug_function = function()
	local filetype = vim.bo.filetype
	local selected_text = trim(vim.fn.getline("."))
	local snippet, offset

	if filetype == "go" then
		snippet = string.format('fmt.Printf("%s: %%+v\\n", %s)', selected_text, selected_text)
		offset = #selected_text + 14
	elseif filetype == "rust" then
		snippet = string.format('println!("%s: {:?}", %s)', selected_text, selected_text)
		offset = #selected_text + 14
	else
		local consolable = vim.tbl_contains(consoles, filetype)
		local printable = vim.tbl_contains(prints, filetype)
		local echoes = vim.tbl_contains(echos, filetype)

		if consolable then
			snippet = string.format("console.log('%s: ', %s)", selected_text, selected_text)
		elseif printable then
			snippet = string.format("print('%s: ', %s)", selected_text, selected_text)
		elseif echoes then
			snippet = string.format('echo "%s $%s"', selected_text, selected_text)
			offset = #selected_text + 14
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

function M.setup(config)
	config = config or {}

	if config.keymaps then
		for _, key in ipairs(config.keymaps) do
			pcall(vim.keymap.del, { "i", "n" }, key)
			vim.keymap.set(
				{ "i", "n" },
				key,
				function()
					M.debug_function()
				end,
				{ noremap = true, silent = true, nowait = true, desc = "Spits out a print statement in your language" }
			)
		end
	end
end

return M
