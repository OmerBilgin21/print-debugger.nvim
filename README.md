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

I use these mostly, therefore created it for them for now.
Starting from Go, I will extend it whenever I have time.

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

TODO: Add languages. Currently planned: Go, Rust, PHP, Bash Script, Java
