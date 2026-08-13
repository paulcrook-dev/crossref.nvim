# crossref.nvim

Jump to code in sibling repos via `@repo:path` comments.

If your workspace has multiple interrelated repos (infra, platform, charts, etc.),
write cross-references in comments and navigate them instantly.

## Syntax

In any file, write a reference as a comment:

```
# @aws-infra-qubiq:modules/iam/roles.tf
```

Optionally pin a line:

```
# @project-repo-platformer:src/aws_auth.py#L42
```

The `@` character at the start distinguishes cross-refs from other annotations.

## Installation

### lazy.nvim / LazyVim

```lua
{
  "your-org/crossref.nvim",
  opts = {
    repos_root = "~/projects/devops",
  },
  keys = {
    { "<leader>rf", function() require("crossref").follow() end, desc = "Follow @repo:path cross-ref" },
    { "<leader>rr", "<cmd>Refs<cr>", desc = "Search cross-repo refs" },
  },
}
```

### From a local checkout (before pushing to GitHub)

```lua
{
  dir = "~/projects/crossref.nvim",
  -- rest is the same
}
```

### packer.nvim

```lua
use({
  "your-org/crossref.nvim",
  config = function()
    require("crossref").setup({ repos_root = "~/projects/devops" })
    require("crossref.telescope").setup({ repos_root = "~/projects/devops" })
  end,
})
```

## Usage

| Key           | Action                            |
| ------------- | --------------------------------- |
| `<leader>rf`  | Jump to the `@repo:path` under cursor |
| `<leader>rr`  | Open Telescope picker across all repos |
| `:Refs`       | Same — Telescope picker           |

If the cursor is not on a cross-ref when you press `<leader>rf`,
the plugin falls back to normal `gf` behaviour.

### Resolution

Given `@base-devel:odoo/addons/foo/__init__.py#L12`, the plugin resolves to:

```
<repos_root>/base-devel/odoo/addons/foo/__init__.py
```

and jumps to line 12. If the file doesn't exist, a warning is shown.

## Configuration

| Option       | Default                | Description               |
| ------------ | ---------------------- | ------------------------- |
| `repos_root` | `~/projects/devops`    | Parent directory of repos |

## Requirements

- Neovim >= 0.9
- Telescope (optional, for `:Refs` picker)
