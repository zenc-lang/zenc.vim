# zenc.vim

This is a [Vim](https://www.vim.org/)/[Neovim](https://neovim.io/) plugin providing syntax highlighting and smart indentation for the [Zen C](https://github.com/z-libs/Zen-C) programming language.

NOTE: This plugin should work fine for most Zen C code that you'll encounter or write, but there may still be unhandled edge cases. Please open an issue for any broken syntax highlighting or indentation that you find.

### Installation

#### Plugin Manager Install

If you use a plugin manager, please consult your plugin manager's docs for installation instructions. Generally you shouldn't need to specify anything beyond the plugin source (e.g. `zenc-lang/zenc.vim`).

For users of [lazy.nvim](https://github.com/folke/lazy.nvim) or [yegappan/lsp](https://github.com/yegappan/lsp), note that this plugin already does its own lazy loading (it will only be loaded when you open a `.zc` file). As such, you don't need to set any additional lazy loading options for this plugin.
```vim
Plug 'zenc-lang/zenc.vim'

setl omnifunc=LspOmniFunc
au filetype zenc call LspAddServer([#{
            \    name: 'zenc',
            \    filetype: ['zenc'],
            \    path: 'zc',
            \    args: ['lsp']
            \  }])
```

#### Manual Install

Vim:

```bash
# Replace "manual" with whatever namespace you prefer:
git clone https://github.com/zenc-lang/zenc.vim.git ~/.vim/pack/manual/start/zenc.vim
```

Neovim:

```bash
# Replace "manual" with whatever namespace you prefer:
git clone https://github.com/zenc-lang/zenc.vim.git ~/.local/share/nvim/site/pack/manual/start/zenc.vim
```

### Configuration

To take advantage of the smart indentation features that this plugin provides, make sure the following options are set in your config (some or all of these may be enabled by default, but it won't hurt to explicitly enable them regardless).

Vim:

```vim
filetype indent plugin on
packadd comment
```

Neovim:

```lua
vim.cmd("filetype indent plugin on")
```
