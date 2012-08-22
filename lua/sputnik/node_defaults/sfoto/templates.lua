module(..., package.seeall)

NODE = {
   title="SFoto Templates",
   prototype="@Lua_Config",
}
NODE.content=[=========[

ALBUM = [======[

$if_has_hidden[[
  <p><img src="$lock_icon_url"/> This album has $num_hidden hidden items.</p><br/>
]]

<table>
 $rows[=[
  <tr>
   $photos[==[
    <td style="vertical-align: middle; text-align: center; min-width: 150px; min-height: 150px; border: none;">
     <a href="$album_url/$id" style="min-height: 150px">
      <img src="$thumb"/>
     </a>
    </td>
   ]==]
  </tr>
 ]=]
</table>

]======]

ALBUM_FOR_VIEWER = [======[
  <div id="sfoto_popup_background">
   <div id="sfoto_side_panel">
     <h1 id="image_title">$title</h1>
     <ul id="sfoto_viewer_toolbar">
       <li><a id="sfoto_viewer_toolbar_close" href="#">Close viewer</a></li>
       <li><a id="sfoto_viewer_toolbar_permalink" href="#">Link</a></li>       
       <li><a id="sfoto_viewer_toolbar_full_size" href="#">Full size</a></li>
     </ul>
     $if_has_hidden[[<p><img src="$lock_icon_url"/> This album has $num_hidden hidden items.</p><br/>
     ]]
   </div>
   <div id="sfoto_popup_main_image">
    <div id="sfoto_popup_main_image_cell">
     <img src=""/>
     <div id="mediaplayer_container">
      <div id="mediaplayer">Video Player Goes Here</div>
     </div>
    </div>
   </div>
   <div id="sfoto_popup_thumbnail_scroll_pane">
    <div id="sfoto_popup_thumbnail_strip">
     <table>
      <tr><td id="sfoto_popup_thumbnail_strip_buffer">Start</td></tr>
      $rows[=[
      <tr>
       $photos[==[
        $if_photo[[
        <td class='sfoto_thumbnail_box'>
         <div id="sfoto_thumbnail_$id" data-sized-url="$sized" data-full-size-url="$original" class="sfoto_thumbnail" href="$album_url/$id">
          <img src='$thumb'/>
         </div>
        </td>
        ]]
        $if_video[[
        <td class='sfoto_thumbnail_box sfoto_thumbnail_box_video'>
         <div id="sfoto_thumbnail_$id" data-sized-frame-url="$sized_video_frame" data-video-file="$video_file" class="sfoto_thumbnail sfoto_video_thumbnail" href="$album_url/$id">
          <img width="150px" height="100px" src='$video_thumb'/>
          <div class="sfoto_video_play_icon">
           <img src="http://media.freewisdom.org/tmp/play.png"/>
          </div>
         </div>
        </td>    
        ]]

       ]==]
      </tr>
      ]=]
      <tr><td id="sfoto_popup_thumbnail_strip_buffer">End<br/><br/><br/><br/><br/><br/><br/></td></tr>
     </table>
    </div> <!-- #sfoto_popup_thumbnail_strip-->
   </div> <!-- #sfoto_popup_thumbnail_scroll_pane -->
  </div> <!-- #sfoto_popup_background -->
]======]

--BOLD_COLOR_1 = "#1B8B9A" -- a bold color used for the larger elements
--BOLD_COLOR_2 = "#093D59" -- a bold color used for the smaller elements

INDEX = [======[

<div id="sfoto_popup_scroll_pane">  
</div> <!-- #sfoto_popup_scroll_pan -->

<table>
 <tr>
 <td colspan="6">
  <a href="$reverse_url" style="text-decoration: none">reverse the order</a>
  | jump to: 
  $months[[ <a href="#month_$id" style="text-decoration: none">$short_name</a>]]
 </tr>
 $months[=[ 
  <tr><th colspan="6" class="date" style="background: #333333; color: white;">$name $year<a name="month_$id"></a></th></tr>
  $rows[==[
   <tr>
    $dates[===[
     <th class="$odd date">$date</th>
    ]===]
    $if_blanks[[<td class="$odd" colspan="$blanks" style="mid-width: $width{}px;">&nbsp;</td>]]
   </tr>
   <tr>
    $items[===[
     <td class="$odd" style="min-width: 160px;">
      $if_blog[====[
       <a class="blog" href="$url" class="sfoto_blog_link">
        <p class="sfoto_blog_title">$title </p>
        <center><img src="$blog_thumb"/></center>
       </a>
      ]====]
      $if_album[====[
       <a href="$url" title="$title" class="sfoto_album_link"><img src="$thumbnail"/></a>
       <br/>$title
      ]====]
     </td>
    ]===]
    $if_blanks[[<td class="$odd" colspan="$blanks">&nbsp;</td>]]
   </tr>
   <tr>
    <td colspan="6" style="background: #333333; color: white;">
     <div id="controller_$row_id" style="display:none;">
      <table class="sfoto_toolbar">
       <tr>
        <td><a href="#" onclick="hideBlog('$row_id'); return false;" style="font-size: 200%;">&#10799;</a></td>
        <td>&#124;</td>
        <td><a id="permalink_$row_id">permalink</a></td>
       </tr>
      </table>
     </div>
     <div id="expander_$row_id"
          style="background:white; color: black; display:none; padding: 15px;">
     </div>
     <div id="controller2_$row_id" style="display:none; color: white;">
      <a href="#" onclick="hideBlog('$row_id'); return false;" style="text-decoration:none; color:white; color: yellow;">hide</a>
     </div>
    </td>
   </tr>
  ]==]
]=]
</table>
]======]

CSS_FOR_INDEX = [====[
.odd {
   background: #999999;
   border: none;
}
.even
{
   background: #cccccc;
   border: none;
} 
.date {
   font-size: 300%;
   padding: 0 0 0 0.2em;
   text-align: left;                               
   font-family: 'Sputnik Header Web Font';
}
.blog {
   display: block;
   font-size: 120%;
   border: 1px solid gray;
   background: white;
   padding: 3px;
   min-height: 94px;
   min-width: 150px;
   text-decoration: none;
}
.blog:hover {
   background: #ffd;
}

.sfoto_blog_title {
   margin-top: 0px; height: 50px;
}
table.sfoto_toolbar { border:none; margin: 0; padding: 0; }
.sfoto_toolbar tr { margin: 0; padding: 0; }
.sfoto_toolbar tr td { vertical-align: middle; border: none; color: gray; margin: 0; padding: 0; padding-right: .5em;    }
.sfoto_toolbar tr td a {  color: white; text-decoration: none; }
.sfoto_toolbar tr td a:hover {  color: yellow; }

#sfoto_popup_scroll_pane {
 width: 100%;
 height: 100%;
 position: fixed;
 top: 0;
 left: 0;
 overflow: hidden; 
 background: rgba(0,0,0,0.95);
 z-index: 100000;
 display: none;
}

#image_title {
 color: white;
 font-size: 14pt;
 border-bottom: 1px solid gray;
}

#image_title_0 {
-webkit-transform: rotate(-90deg); 
-moz-transform: rotate(-90deg);	
transform: rotate(-90deg);
transform-origin: top left;  
color: white;
position: absolute;
top: 365;
height: 50px;
width: 800px;
left: -350px;
text-align: right;
//border: 1px solid orange;
}

#sfoto_popup_background {
 //display: box;
 padding: 10px;
 color: #ddd;
}

#sfoto_popup_main_image {
 position: absolute;
 top: 0px;
 left: 0px;
 //width: 810px;
 width: 100%;
 //height: 810px;
 height: 100%;
 text-align: center;
 display: table;
 margin: 0;
 padding: 0;
}

#sfoto_popup_main_image_cell {
 vertical-align: middle;
 display: table-cell;
}

#sfoto_popup_main_image_cell img {
 border-radius: 10px;
 vertical-align: middle;
}

#mediaplayer_container {
 border-radius: 10px;
 vertical-align: middle;
 border: 5px solid gray;
 width: 805px;
 margin: 0px auto;
 display: none;
}

#sfoto_popup_thumbnail_scroll_pane {
 position: absolute;
 top: 0px;
 right: 0px;
 overflow-y: hidden;
 height: 100%;
 width: 170px;
 margin: 0;
 padding: 0;
 border-left: 1px solid gray;
}

#sfoto_side_panel {
position: absolute;
 top: 0px;
 left: 0px;
 overflow-y: hidden;
 border-right: 1px solid gray;
 height: 100%;
 width: 170px;
 margin: 0;
 padding: 0px;
 z-index: 1000000;
}

div#sfoto_popup_thumbnail_strip {
 display: box;
 height: 800px;
 margin: 0;
 padding: 0;
 top: -200px;
 opacity: 0.4;
}

div#sfoto_popup_thumbnail_strip_buffer {
 height: 200px;
 display: table-cell;
 color: white;
 text-align: center;
 width: 100%;
}

td.sfoto_thumbnail_box {
 vertical-align: middle;
 text-align: center;
 width: 100%;
 height: 155px;
 border: 1px solid gray;
 margin: 2px;
 background: black;
}

td.sfoto_thumbnail_box_video {
 background: #999 !important;
}

.sfoto_thumbnail {
 position: relative;
}

.sfoto_video_play_icon {
 position: absolute;
 top:9px;
 left: 40px;
 border: 6px solid black;
 border-radius: 7px;
 padding: 5px 10px;
 opacity: 0.6;

}

.sfoto_thumbnail_box img {
 border: none;
}
.sfoto_thumbnail_box img.active {
 border: 2px solid yellow;
}

.sfoto_video_play_icon img {
 border: none !important;
}

#sfoto_viewer_toolbar {
  list-style-type: none;
  margin: 0;
  padding: 0;
}
#sfoto_viewer_toolbar > li > a {
   display: block;
   border: 1px solid white;
   border-radius: 4px;
   background: gray;
   padding: 5px;
   margin: 3px;
   color: white;
   text-decoration: none;
}

]====]

SIMPLE_IMAGE_GRID = [====[
<div width='100%' style="margin-top: 20px; margin-bottom:20px">
 <center>
  <div style='position:relative;' class='simple-image-grid'> 
   $rows[[
    $photos[=[
     <a href="$link" class='local'> 
        <img src="$photo_url"/>
     </a>
    ]=]<br/> 
    ]]
  </div>
 </center>
</div>
]====]


MIXED_ALBUM = [====[
<div width='100%' style="margin-top: 20px; margin-bottom:20px;">
 <center>
  <div style='position:relative; width: 635px; margin-left: auto;  margin-right: auto;' class='image-links'>
   $do_photos[[
     <a href="$link" class='local'> 
        <img style="position: absolute; left: $left; top: $top;" 
             width="$width"
             height="$height"
             src="$photo_url"
             title="$title"/>
     </a>
   ]]
  
   <img style='border:none; min-height: $height{}px' 
        src='http://www.freewisdom.org/etc/blank.gif'/>
  </div>
 </center>
</div>

]====]

SINGLE_PHOTO = [==[
  <a href="$next_link#title" title="$note"><img src="$photo_url"/></a>
  <br/>
  <a href="$prev_link#title" style="text-decoration: none;">&lt;</a>
  <a href="$original_size">original size</a> (large image)
  <a href="$next_link#title" style="text-decoration: none;">&gt;</a>
]==]

FOR_THUMB = [[
   <style type="css">
     a:link img {border-style: none;}     
   </style>
   <div style="width: $width{}px">
$html
   </div>"
]]

]=========]
