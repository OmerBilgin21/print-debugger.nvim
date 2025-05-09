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
	local snippet
	local col

	if filetype == "go" then
		if selected_text == "" then
			snippet = string.format('fmt.Printf(" \\n")', selected_text, selected_text)
			col = 13
		else
			snippet = string.format('fmt.Printf("%s: %%+v\\n", %s)', selected_text, selected_text)
			col = 16
		end
	elseif filetype == "rust" then
		if selected_text == "" then
			snippet = string.format('println!(" ")', selected_text, selected_text)
			col = 11
		else
			snippet = string.format('println!("%s: {:?}", %s)', selected_text, selected_text)
			col = 14
		end
	else
		local consolable = vim.tbl_contains(consoles, filetype)
		local printable = vim.tbl_contains(prints, filetype)
		local echoes = vim.tbl_contains(echos, filetype)

		if consolable then
			if selected_text == "" then
				snippet = string.format("console.log(' ')", selected_text, selected_text)
				col = 14
			else
				snippet = string.format("console.log('%s: ', %s)", selected_text, selected_text)
				col = 17
			end
		elseif printable then
			if selected_text == "" then
				snippet = string.format("print(' ')", selected_text, selected_text)
				col = 8
			else
				snippet = string.format("print('%s: ', %s)", selected_text, selected_text)
				col = 11
			end
		elseif echoes then
			if selected_text == "" then
				snippet = string.format('echo " "', selected_text, selected_text)
				col = 7
			else
				snippet = string.format('echo "%s $%s"', selected_text, selected_text)
				col = 9
			end
		else
			return
		end
	end
	vim.api.nvim_command("normal! d0D")
	vim.api.nvim_put({ snippet }, "c", true, true)

	local current_pos = vim.api.nvim_win_get_cursor(0)
	local row = current_pos[1]
	vim.api.nvim_win_set_cursor(0, { row, col })
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
