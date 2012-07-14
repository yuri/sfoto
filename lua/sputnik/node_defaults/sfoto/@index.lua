module(..., package.seeall)
NODE = {
   templates = "sfoto/templates",
}
NODE.fields = [[
content.activate = "lua"
]]
NODE.actions = [[
show="sfoto.show_index"
]]

NODE.child_defaults = [[
--patterns = {
--   {"%/brazil%/", 'prototype="sfoto/@index"'}
--}
any = 'prototype="sfoto/@index"'
]]
