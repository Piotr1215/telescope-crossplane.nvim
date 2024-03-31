local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error "This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
end

local crossplane = require("telescope._extensions.crossplane_telescope.init")

return require("telescope").register_extension {
    setup = function(ext_config, config)
    end,
    exports = {
        crossplane_managed = crossplane.show_managed_resources,
        crossplane_resources = crossplane.show_crossplane_resources
},
}
