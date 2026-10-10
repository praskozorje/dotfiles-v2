return {
  "nvim-lualine/lualine.nvim",

  dependencies = {
      "nvim-tree/nvim-web-devicons",

      {
          "lewis6991/gitsigns.nvim",
          config = function()
              require("gitsigns").setup()
          end,
      },
  },

  config = function()
      ----------------------------------------------------------------
      -- Git ahead / behind
      ----------------------------------------------------------------

      local function update_git_ahead_behind(bufnr)
          bufnr = bufnr or vim.api.nvim_get_current_buf()

          if not vim.api.nvim_buf_is_valid(bufnr) then
              return
          end

          local filename = vim.api.nvim_buf_get_name(bufnr)

          if filename == "" then
              return
          end

          local directory = vim.fn.fnamemodify(filename, ":h")

          local command =
          "git -C "
          .. vim.fn.shellescape(directory)
          .. " rev-list --left-right --count HEAD...@{upstream}"

          vim.fn.jobstart(command, {
              stdout_buffered = true,

              on_stdout = function(_, data)
                  if not data or not data[1] then
                      return
                  end

                  local ahead, behind =
                  data[1]:match("(%d+)%s+(%d+)")

                  if not ahead or not behind then
                      return
                  end

                  ahead = tonumber(ahead) or 0
                  behind = tonumber(behind) or 0

                  vim.schedule(function()
                      if not vim.api.nvim_buf_is_valid(bufnr) then
                          return
                      end

                      vim.b[bufnr].git_ahead = ahead
                      vim.b[bufnr].git_behind = behind

                      vim.cmd("redrawstatus")
                  end)
              end,

              on_exit = function(_, exit_code)
                  if exit_code == 0 then
                      return
                  end

                  vim.schedule(function()
                      if not vim.api.nvim_buf_is_valid(bufnr) then
                          return
                      end

                      vim.b[bufnr].git_ahead = 0
                      vim.b[bufnr].git_behind = 0
                  end)
              end,
          })
      end

      local function git_ahead_behind()
          local ahead = vim.b.git_ahead or 0
          local behind = vim.b.git_behind or 0

          local result = {}

          if ahead > 0 then
              table.insert(result, "↑" .. ahead)
          end

          if behind > 0 then
              table.insert(result, "↓" .. behind)
          end

          return table.concat(result, " ")
      end

      ----------------------------------------------------------------
      -- Update Git status only when something relevant happens
      ----------------------------------------------------------------

      local git_status_group =
      vim.api.nvim_create_augroup(
          "LualineGitStatus",
          { clear = true }
      )

      vim.api.nvim_create_autocmd({
          "BufEnter",
          "BufWritePost",
          "FocusGained",
          "ShellCmdPost",
      }, {
          group = git_status_group,

          callback = function(args)
              update_git_ahead_behind(args.buf)
          end,
      })

      ----------------------------------------------------------------
      -- Git diff source
      --
      -- Let gitsigns calculate the buffer diff and simply expose the
      -- result to lualine.
      ----------------------------------------------------------------

      local function git_diff()
          local status = vim.b.gitsigns_status_dict

          if not status then
              return nil
          end

          return {
              added = status.added or 0,
              modified = status.changed or 0,
              removed = status.removed or 0,
          }
      end

      ----------------------------------------------------------------
      -- Lualine
      ----------------------------------------------------------------

      require("lualine").setup({
          options = {
              theme = "auto",

              -- One statusline for the entire Neovim instance.
              globalstatus = true,

              component_separators = {
                  left = "",
                  right = "",
              },

              section_separators = {
                  left = "",
                  right = "",
              },
          },

          sections = {
              ------------------------------------------------------------
              -- Left
              ------------------------------------------------------------

              lualine_a = {
                  "mode",
              },

              lualine_b = {
                  {
                      "branch",
                      icon = "",
                  },

                  {
                      git_ahead_behind,
                  },

                  {
                      "diff",

                      source = git_diff,

                      colored = true,

                      symbols = {
                          added = " ",
                          modified = " ",
                          removed = " ",
                      },
                  },
              },

              lualine_c = {
                  {
                      "filename",

                      -- 0 = filename only
                      -- 1 = relative path
                      -- 2 = absolute path
                      -- 3 = absolute path with shortened home directory
                      path = 1,

                      symbols = {
                          modified = " ●",
                          readonly = " ",
                          unnamed = "[No Name]",
                          newfile = "[New]",
                      },
                  },
              },

              ------------------------------------------------------------
              -- Right
              ------------------------------------------------------------

              lualine_x = {
                  {
                      "diagnostics",

                      symbols = {
                          error = "E:",
                          warn = "W:",
                          info = "I:",
                          hint = "H:",
                      },
                  },

                  "encoding",
                  "fileformat",
                  "filetype",
              },

              lualine_y = {
                  "progress",
              },

              lualine_z = {
                  "location",
              },
          },
      })

      ----------------------------------------------------------------
      -- Initial update
      ----------------------------------------------------------------

      update_git_ahead_behind()
  end,
}
