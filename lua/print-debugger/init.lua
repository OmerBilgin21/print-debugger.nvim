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
M._config = {}

local function lang_config(filetype)
	return M._config[filetype] or {}
end

local function get_prefix(filetype)
	local cfg = lang_config(filetype)
	return cfg.prefix
end

local function get_spread_mode(filetype)
	local cfg = lang_config(filetype)
	return cfg.spread_mode == true
end

local function set_cursor_after_text(text)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_get_current_line()
	local s = string.find(line, text, 1, true)
	if s then
		vim.api.nvim_win_set_cursor(0, { row, (s - 1) + #text })
	else
		vim.api.nvim_win_set_cursor(0, { row, #line })
	end
end

M.debug_function = function()
	local filetype = vim.bo.filetype
	local selected_text = trim(vim.fn.getline("."))
	local snippet

	local prefix = get_prefix(filetype)
	local spread = get_spread_mode(filetype)

	if filetype == "go" then
		local fn = prefix or "fmt.Printf"

		if selected_text == "" then
			snippet = string.format('%s(" \\n")', fn)
		else
			if spread then
				-- util.Log("x: ", x)
				snippet = string.format('%s("%s: ", %s)', fn, selected_text, selected_text)
			else
				-- fmt.Printf / util.Log formatted
				snippet = string.format('%s("%s: %%+v\\n", %s)', fn, selected_text, selected_text)
			end
		end
	elseif filetype == "rust" then
		local fn = prefix or "println!"
		if selected_text == "" then
			snippet = string.format('%s(" ")', fn)
		else
			snippet = string.format('%s("%s: {:?}", %s)', fn, selected_text, selected_text)
		end
	else
		local consolable = vim.tbl_contains(consoles, filetype)
		local printable = vim.tbl_contains(prints, filetype)
		local echoes = vim.tbl_contains(echos, filetype)

		if consolable then
			local fn = prefix or "console.log"
			if selected_text == "" then
				snippet = string.format("%s(' ')", fn)
			else
				snippet = string.format("%s('%s: ', %s)", fn, selected_text, selected_text)
			end
		elseif printable then
			local fn = prefix or "print"
			if selected_text == "" then
				snippet = string.format("%s(' ')", fn)
			else
				snippet = string.format("%s('%s: ', %s)", fn, selected_text, selected_text)
			end
		elseif echoes then
			local fn = prefix or "echo"
			if selected_text == "" then
				snippet = string.format('%s " "', fn)
			else
				snippet = string.format('%s "%s $%s"', fn, selected_text, selected_text)
			end
		else
			return
		end
	end

	vim.api.nvim_command("normal! d0D")
	vim.api.nvim_put({ snippet }, "c", true, true)

	if selected_text ~= "" then
		set_cursor_after_text(selected_text)
	end
end

function M.setup(config)
	config = config or {}
	M._config = config

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
