// We're using a global variable to store the number of occurrences
var DevFeed_SearchResultCount = 0;

// helper function, recursively searches in elements and their child nodes
function DevFeed_HighlightAllOccurencesOfStringForElement(element,keyword) {
  if (element) {
    if (element.nodeType == 3) {        // Text node
      while (true) {
        var value = element.nodeValue;  // Search for keyword in text node
        var idx = value.toLowerCase().indexOf(keyword);

        if (idx < 0) break;             // not found, abort

        var span = document.createElement("span");
        var text = document.createTextNode(value.substr(idx,keyword.length));
        span.appendChild(text);
        span.setAttribute("class","DevFeedHighlight");
        span.style.backgroundColor="yellow";
        span.style.color="black";
        text = document.createTextNode(value.substr(idx+keyword.length));
        element.deleteData(idx, value.length - idx);
        var next = element.nextSibling;
        element.parentNode.insertBefore(span, next);
        element.parentNode.insertBefore(text, next);
        element = text;
        DevFeed_SearchResultCount++;    // update the counter
      }
    } else if (element.nodeType == 1) { // Element node
      if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
        for (var i=element.childNodes.length-1; i>=0; i--) {
          DevFeed_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
        }
      }
    }
  }
}

// the main entry point to start the search
function DevFeed_HighlightAllOccurencesOfString(keyword) {
  DevFeed_RemoveAllHighlights();
  DevFeed_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
function DevFeed_RemoveAllHighlightsForElement(element) {
  if (element) {
    if (element.nodeType == 1) {
      if (element.getAttribute("class") == "DevFeedHighlight") {
        var text = element.removeChild(element.firstChild);
        element.parentNode.insertBefore(text,element);
        element.parentNode.removeChild(element);
        return true;
      } else {
        var normalize = false;
        for (var i=element.childNodes.length-1; i>=0; i--) {
          if (DevFeed_RemoveAllHighlightsForElement(element.childNodes[i])) {
            normalize = true;
          }
        }
        if (normalize) {
          element.normalize();
        }
      }
    }
  }
  return false;
}

// the main entry point to remove the highlights
function DevFeed_RemoveAllHighlights() {
  DevFeed_SearchResultCount = 0;
  DevFeed_RemoveAllHighlightsForElement(document.body);
}
