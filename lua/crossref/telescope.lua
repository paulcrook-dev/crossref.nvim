local M = {}

function M.setup(opts)
  if not pcall(require, "telescope") then
    return
  end

  local config = vim.tbl_deep_extend("force", {
    repos_root = vim.fn.expand("~/projects/devops"),
  }, opts or {})

  local root = config.repos_root:gsub("^~", vim.fn.expand("~"))

  vim.api.nvim_create_user_command("Refs", function()
    require("telescope.builtin").live_grep({
      cwd = root,
      prompt_title = "Cross-Repo Refs",
      default_text = "@[\\w-]+:",
      additional_args = { "--iglob", "!**/.git/**" },
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        local actions_state = require("telescope.actions.state")
        actions.select_default:replace(function()
          local selection = actions_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            local file = selection.filename
            local lnum = selection.lnum
            local full_path = root .. "/" .. file
            if vim.fn.filereadable(full_path) == 1 then
              vim.cmd("edit " .. vim.fn.fnameescape(full_path))
              vim.cmd(":" .. lnum)
            end
          end
        end)
        return true
      end,
    })
  end, {})
end

return M
