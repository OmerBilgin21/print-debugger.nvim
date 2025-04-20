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

Lazy.nvim:

```
return {
  "OmerBilgin21/print-debugger.nvim",
    config = function()
    require("print-debugger").setup({
	keymaps = {
		"<C-g>",
	},
	})
}

```

Packer.nvim:

```
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

Vim-Plug:

```
Plug 'OmerBilgin21/print-debugger.nvim'

lua << EOF
  require('print-debugger').setup({
    keymaps = {
      "<C-g>",
    },
  })
EOF
```

Caution: This will break on data types that does not implement the Debug trait for Rust!
(I dunno Rust, if someone knows a foolproof way, feel free to open a PR.)
