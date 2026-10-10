return {
  "karb94/neoscroll.nvim",

  opts = {
    -- Don't replace C-u, C-d, etc.
    -- Snacks will continue handling those.
    mappings = {},

    hide_cursor = false,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = false,
    easing = "quadratic",
  },

  config = function(_, opts)
    local neoscroll = require("neoscroll")

    neoscroll.setup(opts)

    local scroll_opts = {
      move_cursor = false,
      duration = 50,
      easing = "quadratic",
    }

    vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", function()
      neoscroll.scroll(-3, scroll_opts)
    end, {
      desc = "Smooth scroll up",
    })

    vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", function()
      neoscroll.scroll(3, scroll_opts)
    end, {
      desc = "Smooth scroll down",
    })
  end,
}
