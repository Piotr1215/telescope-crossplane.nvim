# telescope-crossplane.nvim

This [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
extension two pickers that get data from the following `kubeclt` commands:

1. `kubectl get crossplane`
2. `kubectl get managed`

## Requirements

- Neovim (=>v0.9.0)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- `kubectl`

## Install

You can install the extension by using your plugin manager of choice or by
cloning this repository somewhere on your filepath, and then adding the
following somewhere after telescope in your configuration file (`init.vim` or
`init.lua`).

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use "Piotr1215/telescope-crossplane.nvim"

require("telescope").load_extension("telescope-crossplane")
```

## Setup

### Commands

There are two commands available:

```vim
: Telescope telescope-crossplane crossplane_managed
: Telescope telescope-crossplane crossplane_resources
```

It might take a while to load the resources, so be patient.
Once the resources are loaded, you can use the picker to edit the resource YAML
in a new terminal buffer.

The new buffer will auto close once you save and exit the buffer without errors.
In case of errors, the buffer will stay open, and the error message from
`kubectl` will be shown.

### Keymaps

The plugin doesn't define any keymaps to avoid conflicts. To add keymaps, you can
add the following to your `init.vim` or `init.lua`. The following example uses
`<Leader>tcm` and `<Leader>tcr`, but you can use any keymaps you want.

```vim
vim.keymap.set("n", "<Leader>tcm", ":Telescope telescope-crossplane crossplane_managed<CR>")
vim.keymap.set("n", "<Leader>tcr", ":Telescope telescope-crossplane crossplane_resources<CR>")
```

### Development

Add this do your `init.vim` or `init.lua` to load the plugin from the local environment:

```lua
vim.opt.runtimepath:prepend("~/.../crossplane-telescope.nvim")
```

## Roadmap

- Add `KUBECONFIG` support
- Add `kubectl` pass through support so the picker can select any resource
