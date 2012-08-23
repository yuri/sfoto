module(..., package.seeall)

INDEX = [===[

var sfoto = {};

sfoto.flashplayer_url = "http://media.freewisdom.org/jwplayer/player.swf";
sfoto.player_streamer_url = "rtmp://sdlpzhovxizfl.cloudfront.net/cfx/st";

sfoto.close_viewer = function() {
   $$("#sfoto_popup_scroll_pane").fadeOut(500);
   $$("body").css("overflow", "auto");
   //document.mozCancelFullScreen();
   return false;
}

sfoto.advance_to_thumbnail = function(thumbnail) {
   if (thumbnail) {
      var id = $$(thumbnail).attr("id").substring(16);
      var links = {};
      links.sized_url = $$(thumbnail).attr("data-sized-url");
      links.sized_frame_url = $$(thumbnail).attr("data-sized-frame-url");
      links.full_size_url = $$(thumbnail).attr("data-full-size-url");
      links.video_file = $$(thumbnail).attr("data-video-file");
      links.sputnik_node = $$(thumbnail).attr("href");
      sfoto.advance_to_photo(id, links);
   }
}

sfoto.advance_to_photo = function (id, links) {
   if (links.sized_frame_url) {
      $$("#sfoto_popup_main_image img").hide();
      $$("div#mediaplayer_container").show();
      jwplayer("mediaplayer").setup({
            flashplayer: sfoto.flashplayer_url,
            file: links.video_file,               
            image: links.sized_frame_url,
            height: 533, width: 800,
            provider: "rtmp",
            streamer: sfoto.player_streamer_url
      });
   }
   else {
      jwplayer("mediaplayer").stop();
      $$("#sfoto_popup_main_image img").show();
      $$("div#mediaplayer_container").hide();
   }
   $$("#sfoto_popup_main_image img").attr("src", links.sized_url);
   $$("#sfoto_viewer_toolbar_permalink").attr("href", links.sputnik_node);
   $$("#sfoto_viewer_toolbar_full_size").attr("href", links.full_size_url);
   $$(".sfoto_thumbnail_box img").attr("class", "");
   $$('#sfoto_thumbnail_'+id+" img").attr("class", "active");

   var thumb = $$('#sfoto_thumbnail_'+id);
   var container = $$("#sfoto_popup_thumbnail_scroll_pane");
   container.animate({
      scrollTop: thumb.offset().top - container.offset().top + container.scrollTop() - 200
   });
}

sfoto.make_modal_popup = function (album_url) {
   //document.documentElement.mozRequestFullScreen();
   $$("body").css("overflow", "hidden");
   $$("#sfoto_popup_scroll_pane").load(album_url + ".show_for_viewer",
      function(){
         // show
         $$("#sfoto_popup_scroll_pane").fadeIn();
         // load the first photo
         var first_thumbnail = $$(".sfoto_thumbnail").get(0);
         sfoto.advance_to_thumbnail(first_thumbnail);
         
         // setup all the event handlers         
         $$('#sfoto_popup_thumbnail_scroll_pane').dragscrollable();         
         $$("#sfoto_popup_thumbnail_strip").hover(function(){
           $$(this).css("opacity", 1);
         },function(){
           $$(this).css("opacity", 0.4);
         });
         $$(".sfoto_thumbnail").click(function(){
            var thumbnail = this;
            sfoto.advance_to_thumbnail(thumbnail);
            return false;
         });
         $$("#sfoto_viewer_toolbar_close").click(sfoto.close_viewer);   
         $$("#sfoto_viewer_toolbar_full_size").click(function(){
            window.open($$(this).attr("href"));
            return false;
         });
         $$("#sfoto_viewer_toolbar_permalink").click(function(){
            window.open($$(this).attr("href"));
            return false;
         });
         $$(document).keydown(function(e){
            var top = $$("#sfoto_popup_thumbnail_scroll_pane").scrollTop();
            if (e.which == 40) { // down
               top += 50;
            }
            if (e.which == 38) { // up
               top -= 50;
            }
            if (e.which == 34) { // page down
               top += 500;
            }
            if (e.which == 33) { // page up
               top -= 500;
            } 
            $$("#sfoto_popup_thumbnail_scroll_pane").scrollTop(top);
         });
         $$
      }
   );
}




$$(document).ready(function(){
  $$(".sfoto_album_link").click(function(){
       sfoto.make_modal_popup($$(this).attr("href"));       
       return false;
  });
});
]===]

