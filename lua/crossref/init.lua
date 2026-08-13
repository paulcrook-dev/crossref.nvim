local M = {}

local defaults = {
  repos_root = vim.fn.expand("~/projects/devops"),
}

local config = {}

function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

function M.follow()
  local word = vim.fn.expand("<cfile>")
  local repo, path, line = word:match("^@([%w-]+):([^#]+)#?L?(%d*)$")
  if not repo then
    vim.cmd("norm! gf")
    return
  end

  local root = config.repos_root:gsub("^~", vim.fn.expand("~"))
  local full_path = root .. "/" .. repo .. "/" .. path

  if vim.fn.filereadable(full_path) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
    if line ~= "" then
      vim.cmd(":" .. line)
    end
  else
    vim.notify("crossref.nvim: file not found: " .. full_path, vim.log.levels.WARN)
  end
end

M.setup({})

return M
