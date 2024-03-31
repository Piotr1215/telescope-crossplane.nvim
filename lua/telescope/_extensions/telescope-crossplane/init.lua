local pickers = require('telescope.pickers')
local config = require('telescope.config').values
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local log = require('plenary.log'):new()
log.level = 'info'

local M = {}

-- Function to fetch and parse resources with a given kubectl command
local function get_resources(kubectl_command)
  local out = vim.fn.system(kubectl_command)

  local resources = {}
  for s in out:gmatch('(%S+)') do
    table.insert(resources, s)
  end
  return resources
end

-- Function to edit a Crossplane resource in a terminal buffer
local function edit_resource(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr) -- Close the Telescope picker

  -- Open a new buffer and set it as unlisted
  vim.cmd('new | setlocal nobuflisted')
  local term_bufnr = vim.api.nvim_get_current_buf()

  -- Execute 'kubectl edit' on the selected resource
  vim.fn.termopen(string.format('kubectl edit %s', selection.value), {
    on_exit = function(job_id, exit_status, event_type)
      if exit_status ~= 0 then
        -- If the command failed, show an error message
        vim.defer_fn(function()
          vim.api.nvim_buf_set_lines(
            term_bufnr,
            0,
            0,
            false,
            { 'Error: kubectl command failed. See output for details.' }
          )
        end, 500)
      else
        -- If successful, close the buffer after a short delay
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(term_bufnr) then
            vim.api.nvim_buf_delete(term_bufnr, { force = true })
          end
        end, 500)
      end
    end,
  })
  vim.cmd('startinsert')
end

-- Function to display resources with Telescope
local function show_resources(command, title)
  local resources_list = get_resources(command)
  pickers
    .new({}, {
      prompt_title = title,
      finder = finders.new_table({
        results = resources_list,
      }),
      sorter = config.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        -- Map <CR> to edit the selected resource
        map('i', '<CR>', edit_resource)
        map('n', '<CR>', edit_resource)
        return true
      end,
      previewer = previewers.new_buffer_previewer({
        title = 'Resource Details',
        define_preview = function(self, entry, status)
          -- Fetch details for the selected resource
          local resource_details =
            vim.fn.system(string.format('kubectl get %s -o yaml', entry.value))

          if vim.v.shell_error ~= 0 then
            vim.api.nvim_buf_set_lines(
              self.state.bufnr,
              0,
              -1,
              false,
              { 'Failed to get resource details.' }
            )
          else
            local lines = vim.split(resource_details, '\n')
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'yaml') -- Enable YAML syntax highlighting
          end
        end,
      }),
    })
    :find()
end

-- Exposed function to show managed resources
function M.show_managed_resources()
  show_resources('kubectl get managed -o name', 'Managed Resources')
end

-- Exposed function to show crossplane resources
function M.show_crossplane_resources()
  show_resources('kubectl get crossplane -o name', 'Crossplane Resources')
end

return M
