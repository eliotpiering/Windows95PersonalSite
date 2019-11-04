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

import * as Trix from 'trix';

window.Trix = Trix;


import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"



let Hooks = {};
Hooks.CardWindow = {
    mounted() {
        moveWindow(this.el.id, this.pushEvent.bind(this));
    },
    destroyed() {
        // removeEventListeners
    }
};

Hooks.TextFileWindow = {
    mounted() {
        attachDownloadButton(this.el);
    },
    updated() {
        updateTrixContent(this.el);
    }
};



let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks});
liveSocket.connect();

const moveWindow = function(id, pushEvent) {
    const winElement = document.getElementById(id);
    const dragBar = winElement.getElementsByClassName("card-header")[0];
    let isMoving = false;
    let initialX = null;
    let initialY = null;
    const initialRect = winElement.getBoundingClientRect();
    const mouseMoveEventHandler = function(e) {
        if(!isMoving) {
            return true;
        } else {
            let x = e.clientX - initialX + "px";
            let y = e.clientY - initialY + "px";
            winElement.style.transition = "transform 5ms ease";
            winElement.style.transform = "translate(" + x + " , " + y + ")";
            return true;
        }
    };
    const mouseUpEventHandler = function(e){
        isMoving = false;

        pushEvent("card_window_moved", {pid: id, x: e.clientX - initialX, y: e.clientY - initialY});
        window.removeEventListener('mousemove', mouseMoveEventHandler);
        window.removeEventListener('mouseup', mouseUpEventHandler);
        return true;
    };

    const mouseDownHandler = function(e){
        if(e.target.getAttribute("phx-click") === "close") {
            return true;
        }
        isMoving = true;
        initialX = e.offsetX + initialRect.left;
        initialY = e.offsetY + initialRect.top;
        window.addEventListener('mousemove', mouseMoveEventHandler);
        window.addEventListener('mouseup', mouseUpEventHandler);
        return true;
    };

    dragBar.addEventListener('mousedown', mouseDownHandler);
};

const attachDownloadButton = function(element) {
    if(element.getElementsByClassName("input-for-resume").length > 0) {
        const button = new Trix.Attachment({ content: "<a href='/resume.pdf' class='btn btn-primary' download>Download PDF Version of this Resume</a>" });
        const editor = element.getElementsByTagName("trix-editor")[0].editor;
        editor.insertAttachment(button);
        editor.insertLineBreak();
        editor.insertLineBreak();
    }
};

const updateTrixContent = function(element) {
    const button = new Trix.Attachment({ content: "<a href='/resume.pdf' class='btn btn-primary' download>Download PDF Version of this Resume</a>" });
    const editor = element.getElementsByTagName("trix-editor")[0].editor;
    editor.insertHTML("<strong></strong>");
}
