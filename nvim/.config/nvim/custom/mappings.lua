local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    },
  },
}

M.undotree =  {
  plugin = true,
  n = {
    ["<leader>u"] = {
      "<cmd> UndotreeToggle <CR>",
      "Toggle Undotree panel",
    }
  }
}

return M
