local luasnip = require 'luasnip'
local snippets = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node

luasnip.add_snippets('lua', {
  snippets('keyset', { text 'vim.keymap.set(', insert(1, 'mode, key, dest'), text ')' }),
})
