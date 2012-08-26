-----------------------------------------------------------------------------
-- Implements utility functions for sfoto a photoalbum / blog combo.
-----------------------------------------------------------------------------
module(..., package.seeall)

local ITEMS_PER_ROW = 5
local util = require("sputnik.util")
require("md5")

-----------------------------------------------------------------------------
-- Given a string in a prefix/YYYY/MM/DD-xyz or prefix/YYYY-MM-DD-xyz format,
-- returns "YYYY", "MM", "DD", and "xyz".
--
-- For example: "photos/2011/06/05/b-seville-alcazar/20110605_046_5615" would
-- get parsed into:
--
--     {
--        root  = "photos",
--        year  = "2011",
--        month = "06",
--        date  = "05",
--        rest  = "b-seville-alcazar/20110605_046_5615"
--     }
--
-----------------------------------------------------------------------------
function parse_id(id)
   local root_id = id:match("[^%/]*")
   id = id:sub(root_id:len()+2)
   return {
      root  = root_id,
      year  = id:sub(1,4),
      month = id:sub(6,7),
      date  = id:sub(9,10),
      rest  = id:sub(12),
   }
end

-----------------------------------------------------------------------------
-- Maps ids to actual file URLs, assuming that the images are stored outside
-- Sputnik.  "id" can be supplied as a string or already parsed into a table.
--
-- See parse_id() for the assumed structure of ids.
--
-- The caller specifies the "type" of the resource ("typ") and provides a link
-- to Sputnik config, where the function can lookup URL patterns for different
-- types. Each URL pattern is assumed to be either a Lua patterns, with a
-- single "%s" or a function that takes ID as the parameter. The function
-- substitutes the rewritten id. The function for rewriting IDs is configurable.
--
-----------------------------------------------------------------------------
function photo_url(id, typ, config)
   typ = typ or "sized"
   --local LOCAL_MODE = true
   if LOCAL_MODE then 
      return "http://localhost/"..typ..".jpg"
   end
   
   local id_rewriter_fn = config.SFOTO_ID_REWRITER_FN or function(id)
      local parsed
      if type(id) == "table" then
         parsed = id
      else
         parsed = parse_id(id)
      end
      return parsed.year.."-"..parsed.month.."-"..parsed.date.."-"..parsed.rest
   end

   id = id_rewriter_fn(id)

   local url_pattern = config.SFOTO_FILE_URL_PATTERNS[typ]
   -- return album_base.."/oddsize/"..id:match("/([^%/]*)$")..".thumb"..typ..".jpg"
   
   local url
   if type(url_pattern)=="function" then
      url = url_pattern(id)
   elseif type(url_pattern)=="string" then
      url = string.format(url_pattern, id)
   else
      error ("URL pattern must be a Lua function or a string.")
   end
   return url
end

local MONTH_NAMES = {
  ["12"] = "December",
  ["11"] = "November",
  ["10"] = "October",
  ["09"] = "September",
  ["08"] = "August",
  ["07"] = "July",
  ["06"] = "June",
  ["05"] = "May",
  ["04"] = "April",
  ["03"] = "March",
  ["02"] = "February",
  ["01"] = "January",
}

-----------------------------------------------------------------------------
-- Groups items into buckets, e.g., for the purpose of grouping photos into
-- rows.
-----------------------------------------------------------------------------
function group(list, field, items_per_bucket)
   local buckets = {}
   local bucket = {[field] = {}}
   for i, item in ipairs(list) do
      table.insert(bucket[field], item)
      if #(bucket[field]) == items_per_bucket then
         table.insert(buckets, bucket)
         bucket = {[field] = {}}
      end
   end
   if #(bucket[field]) > 0 then
      table.insert(buckets, bucket)
   end
   return buckets
end

------------------- MOVE ----------------------------------------------------
tag_expander = {
   rio = "brazil",
   paris = "france",
   ["france-other"] = "france",
   amiens = "france",
   vladivostok="russia",
} ------------------- MOVE --------------------------------------------------

-----------------------------------------------------------------------------
-- Checks if item has the specified tag, considering the expansion of the
-- tags (i.e., "brazil" matches "rio").
-----------------------------------------------------------------------------
local function matches_tag(item, tag)
   if not tag then
      return true
   elseif not item.tags then
      return false
   else
      for t in item.tags:gmatch("[^ ]*") do
         if t == tag or tag_expander[t]==tag then 
            return true
         end
      end
   end
   return false
end

-----------------------------------------------------------------------------
-- Checks if the album or it's photos have the specified tag.
-----------------------------------------------------------------------------
local function album_matches_tag(album, tag)
   if not tag then 
      return true
   end
   for i, photo in ipairs(album.content.photos) do
      if matches_tag(photo, tag) then
         return true
      end
   end
   return false
end


-----------------------------------------------------------------------------
-- Filters a list of icons (albums or posts) by a tag.
-----------------------------------------------------------------------------
function filter_by_tag(items, tag)
   if not tag then return items end
   local tag_items = {}
   for i,v in ipairs(items) do
      if v.sfoto_type == "album" then
         if album_matches_tag(v, tag) then
            table.insert(tag_items, v)
         end
      else
         if matches_tag(v, tag) then
            table.insert(tag_items, v)
         end
      end
   end
   return tag_items
end

-----------------------------------------------------------------------------
-- Sorts items into months.
-----------------------------------------------------------------------------
local function sort_by_month(items, ascending)
   -- group items by month
   local items_by_month = {}
   for i, item in ipairs(items) do
      local parsed = parse_id(item.id) 
      local month = parsed.year.."/"..parsed.month
      if parsed.month:len() > 0 then
         if not items_by_month[month] then items_by_month[month] = {} end
         table.insert(items_by_month[month], item)
      end
   end
 
   local sorter = ascending and function(x,y) return x.id < y.id end
                  or function(x,y) return x.id > y.id end
 
   -- make a list of months for which we have items
   local months = {}
   local month
   for id, items in pairs(items_by_month) do
      month = { id=id, year=id:sub(1,4) }
      month.name = MONTH_NAMES[id:sub(6,7)]
      month.short_name = month.name:sub(1,3):lower()
      if items_by_month[id] then
         month.items = items_by_month[id]
         table.sort(month.items, sorter)
         table.insert(months, month)
      end
   end
   table.sort(months, sorter)
   return months
end


local function pretty_count(count, singular, plural)
   plural = plural or singular.."s"
   if count == 0 then
      return "no "..plural
   elseif count == 1 then
      return "1 "..singular
   else
      return count.." "..plural
   end
end

-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
local function decorate_item(item, sputnik, oddeven)
      local parsed = parse_id(item.id)
      item.if_blog = cosmo.c(item.sfoto_type=="post"){}
      item.if_album = cosmo.c(item.sfoto_type~="post"){}
      if item.sfoto_type == "post" then
          item.url = sputnik:make_url(item.id)
          item.content_url = sputnik:make_url(item.id, "show_content",
                                              {show_title="1"})
          item.blog_thumb = photo_url(item.id, "blog_thumb", sputnik.config)
      else
          local num_photos = 0
          local num_videos = 0
          local thumb_id = item.thumb
          local thumb_type = nil
          for _, v in ipairs(item.content.photos) do
              if v.id == thumb_id then
                 if v.is_video then
                    thumb_type = "video_thumb"
                 else
                    thumb_type = "thumb"
                 end
              end
              if v.is_video then
                 num_videos = num_videos+1
              else
                 num_photos = num_photos+1
              end
          end
          item.count = pretty_count(num_photos, "photo")
                       .. ", " .. pretty_count(num_videos, "video")          
          item.url = sputnik:make_url(item.id)
          item.content_url = sputnik:make_url(item.id, "show_content",
                                              {show_title="1"})
          item.thumbnail = photo_url(item.id.."/"..item.thumb, thumb_type, sputnik.config)
          item.if_fixed_width = cosmo.c(thumb_type == "video_thumb"){}
      end

      item.show_date = (cur_date ~= parsed.date) and parsed.date
                       or "&nbsp;"

      if cur_date ~= parsed.date then
         oddeven:next()
         cur_date = parsed.date
      end
      item.odd = oddeven:get()
end

-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
local function make_row()
   return {
      items={}, 
      dates={},
      if_blanks = cosmo.c(false){},
      row_id = md5.sumhexa(math.random()),
   }
end

-----------------------------------------------------------------------------
-- Turns a list of items (blog posts, albums) into a calendar organized by
-- months.
-----------------------------------------------------------------------------
function make_calendar(items, sputnik, ascending)
   local months = sort_by_month(items, ascending)
   local oddeven = util.new_cycle{"odd", "even"}
   for i, month in ipairs(months) do
      month.rows = {}
      local row = make_row()
      for i, item in ipairs(month.items) do
         item.row_id = row.row_id
         decorate_item(item, sputnik, oddeven)
         table.insert(row.items, item)
         table.insert(row.dates, {date=item.show_date, odd=item.odd})
         if #(row.items) == 5 then
            table.insert(month.rows, row)
            row = make_row()
         end
      end
      -- check if we have a partial row left
      local num_items = #(row.items)
      if num_items > 0 then
         if num_items < ITEMS_PER_ROW then
            oddeven:next()
         end
         row.if_blanks = cosmo.c(num_items <= ITEMS_PER_ROW) {
                            blanks = ITEMS_PER_ROW + 1 - num_items,
                            odd = oddeven:get(),
                            width = 170*(ITEMS_PER_ROW + 1 - num_items),
                         }
         table.insert(month.rows, row)
      end
   end
   return months                                                
end

-----------------------------------------------------------------------------
-- Returns a list of items that the user is allowed to see and the number of
-- excluded items.
-----------------------------------------------------------------------------
function visible_photos(photos, user, sputnik)
   local viewable_items = {}
   local num_hidden = 0
   for i, photo in ipairs(photos) do
      if can_see_photo(photo, user, sputnik) then
         table.insert(viewable_items, photo)
      else
         num_hidden = num_hidden + 1
      end
   end
   return viewable_items, num_hidden
end

function can_see_photo(photo, user, sputnik)
   return (not photo.groups) or
          sputnik.auth:get_metadata(user, photo.groups) == "true"

end
