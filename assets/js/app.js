// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
// import 'bootstrap'

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"


// Live View
import "mdn-polyfills/CustomEvent"
import "mdn-polyfills/String.prototype.startsWith"
import "mdn-polyfills/Array.from"
import "mdn-polyfills/NodeList.prototype.forEach"
import "mdn-polyfills/Element.prototype.closest"
import "mdn-polyfills/Element.prototype.matches"
import "child-replace-with-polyfill"
import "url-search-params-polyfill"
import "formdata-polyfill"
import "classlist-polyfill"

import 'trix'


import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()


window.moveWindow = function(id) {
    var winElement = document.getElementById(id);
    var dragBar = winElement.getElementsByClassName("card-header")[0];
    var isMoving = false;
    var initialX = null;
    var initialY = null;
    var initialRect = winElement.getBoundingClientRect();

    dragBar.addEventListener('mousedown', function(e){
        isMoving = true;
        initialX = e.offsetX + initialRect.left;
        initialY = e.offsetY + initialRect.top;
        return true;
    });
    window.addEventListener('mouseup', function(e){
        isMoving = false;
        //TODO update server side with position of dropped window

        return true;
    });
    window.addEventListener('mousemove', function(e) {
        if(!isMoving) {
            return true;
        } else {
            var x = (e.clientX - initialX) + "px";
            var y = (e.clientY - initialY) + "px";
            winElement.style.transition = "transform 5ms ease";
            winElement.style.transform = "translate(" + x + " , " + y + ")";
            return true;
        }
    });
}
