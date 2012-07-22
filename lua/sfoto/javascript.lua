module(..., package.seeall)

INDEX = [===[

var sfoto = {};

sfoto.close_viewer = function() {
   $$("#sfoto_popup_scroll_pane").fadeOut(500);
   $$("body").css("overflow", "auto");
   //document.mozCancelFullScreen();
   return false;
}

sfoto.advance_to_thumbnail = function(thumbnail) {
   var id = $$(thumbnail).attr("id").substring(16);
   var links = {};
   links.sized_url = $$(thumbnail).attr("data-sized-url");
   links.full_size_url = $$(thumbnail).attr("data-full-size-url");
   links.sputnik_node = $$(thumbnail).attr("href");
   sfoto.advance_to_photo(id, links);
}

sfoto.advance_to_photo = function (id, links) {
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

