return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                gui_style = {
                    fg = "BOLD",
                },
                highlight = {
                    pattern = [[.*<(KEYWORDS)\s*:]],
                    keyword = "fg", 
                    after = "", 
                },
                colors = {
                    error = { "DiagnosticError", "ErrorMsg", "#fb4934" }, 
                    warning = { "DiagnosticWarn", "WarningMsg", "#fe8019" }, 
                    info = { "DiagnosticInfo", "#83a598" }, 
                    default = { "Identifier", "#fabd2f" }, 
                },
            })
        end
    }
}
