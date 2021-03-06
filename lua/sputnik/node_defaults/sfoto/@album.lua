module(..., package.seeall)
NODE = {
   title="sfoto/@album",
   templates="sfoto/templates",
}
NODE.actions = [[
show="sfoto.show_album"
show_content='sfoto.show_album_content'
show_for_viewer = "sfoto.show_album_for_js_viewer"
]]
NODE.fields = [[
content.activate = "lua"
sfoto_type = {2.1, proto="fallback"}
]]
NODE.sfoto_type = "album"

NODE.child_defaults = [=[
   any = [[
      prototype = "sfoto/@album"
      actions = "show='sfoto.show_photo'; show_content='sfoto.show_photo_content';"
   ]]
]=]
NODE.permissions = [[
deny(all_users, "edit")
deny(all_users, "save")
allow(Admin, "edit")
allow(Admin, "save")
allow(all_users, "show_for_viewer")
]]
