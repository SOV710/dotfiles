-- register taskrc filetype
vim.filetype.add({
    filename = {
        ["taskrc"] = "taskrc"
    }
})

-- register taskwarrior language
vim.treesitter.language.register("taskwarrior", "taskrc")

local function register_taskwarrior()
    require("nvim-treesitter.parsers").taskwarrior = {
        install_info = {
            url = "https://github.com/SOV710/tree-sitter-taskwarrior",
            branch = "main",
            revision = "ae67458960c2889f2d561d330ae46a76edcd9aba",
            files = { "src/parser.c" },
            generate = false,
            queries = "queries",
        },
        filetype = "taskrc",
        tier = 3,
    }
end

register_taskwarrior()

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = register_taskwarrior,
})
