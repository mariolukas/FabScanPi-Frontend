name = 'fabscan.directives.FSMJPEGStream'
angular.module(name, []).directive('mjpeg', [
  '$log'
  ($log)->

    restrict: 'E'
    replace: true
    template: '<span></span>'
    scope: 'url': '='
    link: (scope, element, attrs) ->
      scope.$watch 'url', ((newVal, oldVal) ->
        if newVal
          iframe = document.createElement('iframe')
          iframe.setAttribute 'width', '320'
          iframe.setAttribute 'frameborder', '0'
          iframe.setAttribute 'scrolling', 'no'
          iframe.setAttribute 'style' , "float:left; position:absolute;"
          element.replaceWith iframe
          iframeHtml = '<html><head><base target="_parent" /><style type="text/css">html, body { margin: 0; padding: 0; height: 100%; width: 100%; }</style><script> function resizeParent() { var ifs = window.top.document.getElementsByTagName("iframe"); for (var i = 0, len = ifs.length; i < len; i++) { var f = ifs[i]; var fDoc = f.contentDocument || f.contentWindow.document; if (fDoc === document) { f.height = 0; f.height = document.body.scrollHeight; } } }</script></head><body onresize="resizeParent()"><img src="' + newVal + '" style="z-index:1000; width: 320px; height: 240px" onload="resizeParent()" /><div style="background-color: black; text-align:center; width:320px; height:240px; float:left; top:0; z-index:-1000; left:0; position:absolute"><img style="margin-top:100px; width:50px; height:50px;" src="icons/spinner.gif" />"</div></body></html>'
          doc = iframe.document
          if iframe.contentDocument
            doc = iframe.contentDocument
          else if iframe.contentWindow
            doc = iframe.contentWindow.document
          doc.open()
          doc.writeln iframeHtml
          doc.close()
        else
          element.html '<span>Hier Nachricht<img src="icons/spinner.gif"</span>'
        return
      ), true
      return
])