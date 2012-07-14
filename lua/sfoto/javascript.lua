module(..., package.seeall)

INDEX = [===[
      function ahah(url,target) {
         document.getElementById(target).innerHTML = 'fetching data...';
         if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
            req.onreadystatechange = function() {ahahDone(target);};
            req.open("GET", url, true);
            req.send(null);
         } else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHTTP");
            if (req) {
               req.onreadystatechange = function() {ahahDone(target);};
               req.open("GET", url, true);
               req.send();
            }
         }
      }
 
      function ahahDone(target) {
         // only if req is "loaded"
         if (req.readyState == 4) {
            // only if "OK"
            if (req.status == 200 || req.status == 304) {
               results = req.responseText;
               document.getElementById(target).innerHTML = results;
            } else {
               document.getElementById(target).innerHTML="ahah error:\n" +
               req.statusText;
            }
         }
      } 

      function updateTime() {
         setTimeout( 'ahah( "$url", "world_clock", 1)', 1 );
         setTimeout("updateTime()", $timeout);
      }


      function showBlog(id, url, content_url) {
         document.getElementById("controller_"+id).style.display = "block";
         document.getElementById("expander_"+id).style.display = "block";
         document.getElementById("controller2_"+id).style.display = "block";
         document.getElementById("permalink_"+id).href=url;
         ahah(content_url, "expander_"+id, 1);
         window.scrollBy(0,100);
      }

      function hideBlog(id) {
         document.getElementById("controller_"+id).style.display = "none";
         document.getElementById("expander_"+id).style.display = "none";
         document.getElementById("controller2_"+id).style.display = "none";
      }
]===]
