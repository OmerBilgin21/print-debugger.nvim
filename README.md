# Print Debugger:

https://github.com/user-attachments/assets/bdd4509a-9872-48de-af43-f0e860756704

Spits out a print statement for different languages.
I myself am a print debugger, and find it tedious to always write print('data from somewhere', data)
Therefore, I found myself writing a similar code to what is in here to my config.

Thought I'd create a plugin for it to keep it separated from my config.

Currently supported languages are:

- JavaScript and JSReact
- TypeScript and TSReact
- Python
- Lua
- Go
- Rust
- Bash Script

I use these mostly, therefore created it for them for now.

### Installation

#### Lazy.nvim

```lua
return {
  "OmerBilgin21/print-debugger.nvim",
  config = function()
    require("print-debugger").setup({
      keymaps = {
        "<C-g>",
      },
    })
  end,
}
```

#### Packer.nvim

```lua
use({
  "OmerBilgin21/print-debugger.nvim",
  config = function()
    require("print-debugger").setup({
      keymaps = {
        "<C-g>",
      },
    })
  end,
})
```

#### Vim-Plug

```vim
Plug 'OmerBilgin21/print-debugger.nvim'

lua << EOF
  require('print-debugger').setup({
    keymaps = {
      "<C-g>",
    },
  })
EOF
```

---

### Per-language configuration (prefix & spread mode)

You can override the logger function and argument style per filetype.

```lua
require("print-debugger").setup({
  go = {
    prefix = "util.Log",     -- replaces fmt.Printf
    spread_mode = true,     -- util.Log("x: ", x) instead of formatted string
  },
  javascript = {
    prefix = "logger.info", -- replaces console.log
  },
  keymaps = {
    "<C-g>",
  },
})
```

* `prefix` replaces the default logging function for that language.
* `spread_mode` (Go only) disables formatting and passes arguments directly.

Example (Go):

```
util.Log("tokenString: ", tokenString)
```

---

Or, if you would like to define your own keymaps, the `debug_function` is exposed via `print-debugger` module.
Meaning this would also work:

```lua
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
```

If you go with the solution above, you then do not need to call the setup function.

---

Caution: This will break on data types that do not implement the `Debug` trait for Rust.
(I do not know Rust; PRs welcome.)
